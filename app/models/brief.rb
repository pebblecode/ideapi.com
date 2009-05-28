class Brief < ActiveRecord::Base
  # relationships
  has_brief_config
  belongs_to :user
  
  has_many :answers
  has_many :creative_responses
  
  acts_as_commentable
  
  # delegations
  delegate :sections, :to => :brief_config
  
  # callbacks
  after_create :generate_template_answers!
  
  # validations
  validates_presence_of :user, :brief_config, :title
  
  #instance methods
  def generate_template_answers!
    question_count = 0
    sections.each do |section|
      section.questions.each do |question|
        question_count += 1
        self.answers.create(:question => question, :section => section)
      end
    end
    return self.answers.count == question_count
  end
  
  def answer_for(question, section)
    self.answers.find_by_question_id_and_section_id(question.id, section.id)
  end
  
  #class methods
  class << self
  end
  
  private 
  
  def assign_brief_config
    self.brief_config = BriefConfig.current if self.brief_config.blank?
  end
  
end
