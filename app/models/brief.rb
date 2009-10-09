class Brief < ActiveRecord::Base
  # alter ego is the statemachine
  # gem that is being used to control
  # brief states ..
  include AlterEgo
  
  # relationships
  belongs_to :template_brief
  belongs_to :approver, :class_name => 'User'
  
  has_many :brief_items, :order => :position
  
  has_many :user_briefs
  has_many :users, :through => :user_briefs do
    def author=(user)
      proxy_owner.user_briefs.build(:user => user, :brief => proxy_owner, :author => true)
    end
    
    def author
      first :conditions => ["user_briefs.author = true"], :order => :created_at
    end
    
    def authors
      all :conditions => ['user_briefs.author = ?', true]
    end
  end
  
  has_many :invitations, :as => :redeemable
  has_many :watched_briefs
  has_many :watchers, :through => :watched_briefs, :source => :user
  has_many :proposals
  has_many :questions
  
  # VIEWING BRIEFS BY USERS
  has_many :brief_user_views do    
    def record_view_for_user(user)
      for_user(user).viewed!
    end
    
    def for_user(user)
      find_or_create_by_user_id(:user_id => user.id)
    end
  end
  
  acts_as_commentable
  
  accepts_nested_attributes_for :brief_items, 
    :allow_destroy => true, 
    :reject_if => :all_blank
  
  accepts_nested_attributes_for :user_briefs, :allow_destroy => true
  
  # callbacks
  after_create :generate_brief_items_from_template!
  
  # validations
  validates_presence_of :template_brief_id, :title, :most_important_message
  
  # see plugin totally_truncated
  truncates :title
  
  # State machine
  
  include Ideapi::Schizo
  
  state :draft, :default => true do
    handle :publish! do
      ensure_approver_set
      stored_transition_to(:published)
    end  
  end
  
  state :published do
    handle :complete! do
      stored_transition_to(:complete)
    end
    
    handle :review! do
      stored_transition_to(:under_review)
    end
  end
  
  state :under_review do
    handle :complete! do
      stored_transition_to(:complete)
    end
  end
  
  state :complete do
    handle :archive! do
      stored_transition_to(:archived)
    end  
  end
  
  state :archived

  become_schizophrenic

  before_save :ensure_default_state
  
  
  # ACTIVITY STREAM
  fires :brief_created, :on => :create, :actor => "user", :log_level => 1
  fires :brief_updated, :on => :update, :actor => "user", :log_level => 1
  
  def activity_stream(user, options = {})
    options.reverse_merge! :conditions => activity_stream_conditions(user), 
      :order => "created_at DESC"
    
    TimelineEvent.find(:all, options)
  end
  
  def activity_stream_conditions(user)
    [
      '((subject_type = ? AND subject_id = ?) OR (secondary_subject_type = ? AND secondary_subject_id = ?)) AND log_level <= ? AND created_at >= ?',
      "Brief", self.id, "Brief", self.id, role_for_user?(user)[:log_level], user.last_viewed_brief(self)
    ]
  end
  
  #has_many :timeline_events, :as => [:subject, :secondary_subject]
  #has_many :timeline_events, :as => :secondary_subject
      
  # find questions and proposals etc
  # that need answerings, approving ..
  def activity_to_view(user)
    if author?(user) || approver?(user)
      activity = {
        :question => questions.unanswered,
        :idea => proposals.published
      }.reject {|k,v| v.blank? }
    else 
      return {}
    end
  end
  
  def author?(user)
    self.belongs_to?(user) && user_briefs.find_by_user_id(user).author?
  end
  
  def role_for_user?(user)
    if author?(user)
      Roles::AUTHOR
    elsif self.approver?(user)
      Roles::APPROVER
    else
      Roles::COLLABORATOR
    end
  end
  
  module Roles
    AUTHOR = {:log_level => 3, :label => 'author'}
    APPROVER = {:log_level => 2, :label => 'approver'}
    COLLABORATOR = {:log_level => 1, :label => 'collaborator'}
  end
  
  # INDEXING
  
  # define_index do 
  #   indexes title, most_important_message
  #   indexes brief_items.body, :as => :brief_items_content
  #   
  #   where "state = 'published'"
  #   
  #   set_property :delta => true
  # end

  # OWNERSHIP
  
  def proposal_list_for_user(a_user)
    if author_or_approver?(a_user)
      proposals.active
    else
      proposals.for_user(a_user)
    end
  end
  
  def author_or_approver?(a_user)
    belongs_to?(a_user) || approver?(a_user)
  end
  
  def belongs_to?(a_user)
    users.authors.include?(a_user)
  end
  
  def approver?(a_user)
    a_user == approver
  end
  
  def collaborator?(a_user)
    users.include?(a_user)
  end
  
  def user=(user)
    self.users.author = user
  end
  
  def user
    self.users.author
  end
  
  class << self
    def grouped
      all.group_by(&:state)
    end
    
    def sample
      published.find(:first)
    end
  end
  
  private 
  
  def ensure_approver_set
    self.approver_id = self.user if self.approver_id.blank?
  end
  
  def generate_brief_items_from_template!
    raise 'TemplateBriefMissing' if template_brief.blank?
  
    template_brief.template_questions.each do |question|
      self.brief_items.create(:title => question.body, :template_question => question)
    end
    
    return (brief_items.count == template_brief.template_questions.count)
  end
  
end
