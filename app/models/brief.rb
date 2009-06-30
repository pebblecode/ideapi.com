class Brief < ActiveRecord::Base
  # alter ego is the statemachine
  # gem that is being used to control
  # brief states ..
  include AlterEgo
  
  # relationships
  belongs_to :author
  belongs_to :template_brief
  
  has_many :brief_items, :order => :position
  accepts_nested_attributes_for :brief_items, :allow_destroy => true, :reject_if => :all_blank
  
  has_many :creative_questions
    
  # callbacks
  after_create :generate_brief_items_from_template!
  before_validation_on_create :assign_template
  
  # validations
  validates_presence_of :author_id, :template_brief_id, :title
  
  
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
  end
  
  state :published do 
    handle :close! do
      transition_to :closed
      save!
    end
    
    handle :review! do
      transition_to :peer_review
      save!
    end
  end
  
  state :peer_review do
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
  
  
  private 
  
  def assign_template
    # this is flawed and will be removed!
    self.template_brief_id = TemplateBrief.last.id if self.template_brief_id.blank?
  end
  
  def generate_brief_items_from_template!
    raise 'TemplateBriefMissing' if template_brief.blank?
  
    template_brief.template_questions.each do |question|
      self.brief_items.create(:title => question.body)
    end
    
    return (brief_items.count == template_brief.template_questions.count)
  end
  
  
end
