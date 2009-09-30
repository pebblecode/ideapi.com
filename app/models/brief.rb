class Brief < ActiveRecord::Base
  # alter ego is the statemachine
  # gem that is being used to control
  # brief states ..
  include AlterEgo
  
  # relationships
  belongs_to :user
  belongs_to :template_brief
  belongs_to :approver, :class_name => 'User'
  
  has_many :brief_items, :order => :position
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
  
  accepts_nested_attributes_for :watched_briefs, :allow_destroy => true
  
  # callbacks
  after_create :generate_brief_items_from_template!
  
  # validations
  validates_presence_of :user_id, :template_brief_id, :title, :most_important_message
  
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
    handle :close! do
      stored_transition_to(:closed)
    end  
  end
  
  state :closed

  become_schizophrenic

  before_save :ensure_default_state
  
  
  # ACTIVITY STREAM
  fires :brief_updated, :on => :update, :actor => :user
  
  # INDEXING
  
  define_index do 
    indexes title, most_important_message
    indexes brief_items.body, :as => :brief_items_content
    
    where "state = 'published'"
    
    set_property :delta => true
  end

  # OWNERSHIP
  
  def belongs_to?(a_user)
    user == a_user
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
    self.approver_id = self.user_id if self.approver_id.blank?
  end
  
  def generate_brief_items_from_template!
    raise 'TemplateBriefMissing' if template_brief.blank?
  
    template_brief.template_questions.each do |question|
      self.brief_items.create(:title => question.body, :template_question => question)
    end
    
    return (brief_items.count == template_brief.template_questions.count)
  end
  
end
