class Brief < ActiveRecord::Base
  # alter ego is the statemachine
  # gem that is being used to control
  # brief states ..
  include AlterEgo
  
  # relationships
  belongs_to :author
  belongs_to :brief_template
  has_many :brief_answers
  has_many :creative_proposals
  
  acts_as_commentable
  
  # delegations
  delegate :brief_sections, :to => :brief_template
  
  # callbacks
  after_create :generate_template_brief_answers!
  
  # validations
  validates_presence_of :author, :brief_template, :title
  
  #instance methods
  
  # ---------
  # generate_template_brief_answers!
  # ---------
  # this rather ill looking method basically
  # cycles through the sections in the brief template
  # and for each question in the section
  # it mocks out an answer for this brief so
  # it can be answered inline with the question
  
  def generate_template_brief_answers!
    brief_question_count = 0
    brief_sections.each do |brief_section|
      brief_section.brief_questions.each do |brief_question|
        brief_question_count += 1
        self.brief_answers.create(:brief_question => brief_question, :brief_section => brief_section)
      end
    end
    return self.brief_answers.count == brief_question_count
  end
  
  # yields an answer object for the associated question and section set
  def brief_answer_for(brief_question, brief_section)
    self.brief_answers.find_by_brief_question_id_and_brief_section_id(brief_question.id, brief_section.id)
  end
  
  # class methods
  class << self
  end
  
  # State machine
  
  # ensure default state is set.
  def before_create
    self.state = self.state if read_attribute(:state).blank?
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
    (read_attribute(:state) || Brief.default_state).to_sym
  end

  # create a named scope for all the defined scopes
  class_eval do
    states.each do |state_name, state|
      named_scope state_name, :conditions => ["state = ?", state_name.to_s]
    end
  end
  
  private 
  
  def assign_brief_config
    self.brief_config = BriefConfig.current if self.brief_config.blank?
  end
  
end
