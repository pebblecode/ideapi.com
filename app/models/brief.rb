class Brief < ActiveRecord::Base
  # relationships
  belongs_to :author
  belongs_to :brief_template
  has_many :brief_answers
  has_many :creative_responses
  
  acts_as_commentable
  
  # delegations
  delegate :brief_sections, :to => :brief_template
  
  # callbacks
  after_create :generate_template_brief_answers!
  
  # validations
  validates_presence_of :author, :brief_template, :title
  
  #instance methods
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
  
  def brief_answer_for(brief_question, brief_section)
    self.brief_answers.find_by_brief_question_id_and_brief_section_id(brief_question.id, brief_section.id)
  end
  
  # class methods
  class << self
  end
  
  private 
  
  def assign_brief_config
    self.brief_config = BriefConfig.current if self.brief_config.blank?
  end
  
end
