class Brief < ActiveRecord::Base
  # alter ego is the statemachine
  # gem that is being used to control
  # brief states ..
  include AlterEgo
  
  # relationships
  belongs_to :user
  belongs_to :template_brief
  
  has_many :brief_items, :order => :position
  has_many :invitations, :as => :redeemable
  
  has_many :watched_briefs
  has_many :watchers, :through => :watched_briefs, :source => :user
  
  def all_involved
    [user] + watchers
  end
  
  def brief_items_grouped_by_section
    brief_items.group_by(&:section_name)
  end
  
  accepts_nested_attributes_for :brief_items, :allow_destroy => true, :reject_if => :all_blank
  
  has_many :questions
    
  # callbacks
  after_create :generate_brief_items_from_template!
  
  # validations
  validates_presence_of :user_id, :template_brief_id, :title, :most_important_message
  
  # see plugin totally_truncated
  truncates :title
  
  # State machine
  
  # ensure default state is set.
  before_create :ensure_default_state
  
  def ensure_default_state
     (self.state = Brief.default_state) if read_attribute(:state).blank?
  end
  
  # define states and associated actions

  state :draft, :default => true do
    handle :publish! do
      transition_to :published
      save!
    end
    #transition :to => :published, :on => :publish!, :if => proc { !brief_items.answered.empty? }
  end
  
  state :published do 
    handle :complete! do
      transition_to :complete
      save!
    end
    
    handle :review! do
      transition_to :under_review
      save!
    end
  end
  
  state :under_review do
    handle :complete! do
      transition_to :complete
      save!
    end
  end
  
  state :complete do
    handle :close! do
      transition_to :closed
      save!
    end  
  end
  
  state :closed
  
  # overwrite accessors so we can save to the database
  
  def state=(transition_to)
    write_attribute(:state, transition_to.to_s)
  end

  def state
    ensure_default_state
    read_attribute(:state).to_sym
  end

  # dynamically create some class level, and instance methods
  # for use with the statemachine defined states.
  class_eval do
    states.each do |state_name, state|
      # create a named scope for all the defined scopes
      named_scope state_name, :conditions => ["state = ?", state_name.to_s]
      
      # create a state_name? instance method for each state ..
      # for example @brief.draft? => true
      define_method("#{state_name}?", lambda { self.state == state_name }) 
    end
  end
  
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
  end
  
  
  # VIEWING BRIEFS BY USERS
  
  has_many :brief_user_views do    
    def record_view_for_user(user)
      for_user(user).viewed!
    end
    
    def for_user(user)
      find_or_create_by_user_id(:user_id => user.id)
    end
  end
  

  private 
  
  def generate_brief_items_from_template!
    raise 'TemplateBriefMissing' if template_brief.blank?
  
    template_brief.template_questions.each do |question|
      self.brief_items.create(:title => question.body, :template_question => question)
    end
    
    return (brief_items.count == template_brief.template_questions.count)
  end
  
end
