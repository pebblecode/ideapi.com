class Brief < ActiveRecord::Base
  # alter ego is the statemachine
  # gem that is being used to control
  # brief states ..
  include AlterEgo
  
  # relationships
  belongs_to :author
  belongs_to :template_brief
  
  has_many :brief_items, :order => :position
  has_many :creative_questions
    
  # delegations
  # delegate :brief_sections, :to => :brief_template
  
  # callbacks
  # after_create :generate_template_brief_answers!
  
  # validations
  validates_presence_of :author_id, :template_brief_id, :title
  
  #instance methods  
  # def answered_sections
  #   @answered_sections ||= brief_answers.answered.map(&:brief_section).uniq
  # end
  
  # ---------
  # generate_template_brief_answers!
  # ---------
  # this rather ill looking method basically
  # cycles through the sections in the brief template
  # and for each question in the section
  # it mocks out an answer for this brief so
  # it can be answered inline with the question
  
  # def generate_template_brief_answers!
  #   brief_question_count = 0
  #   brief_sections.each do |brief_section|
  #     brief_section.brief_questions.each do |brief_question|
  #       brief_question_count += 1
  #       self.brief_answers.create(:brief_question => brief_question, :brief_section => brief_section)
  #     end
  #   end
  #   return self.brief_answers.count == brief_question_count
  # end
  
  # yields an answer object for the associated question and section set
  # def brief_answer_for(brief_question, brief_section)
  #   self.brief_answers.find_by_brief_question_id_and_brief_section_id(brief_question.id, brief_section.id)
  # end
  
  # class methods
  class << self
  end
  
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
  
  # def assign_brief_config
  #   self.brief_config = BriefConfig.current if self.brief_config.blank?
  # end
  
end
