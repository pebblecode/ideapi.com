class Brief < ActiveRecord::Base
  # relationships
  has_brief_config
  belongs_to :user
  
  has_many :answers
  has_many :creative_responses
  
  # delegations
  delegate :sections, :to => :brief_config
  
  # callbacks
  
  # validations
  validates_presence_of :user, :brief_config
  
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
  
  
  #class methods
  class << self
  end
  
  private 
  
  def assign_brief_config
    self.brief_config = BriefConfig.current if self.brief_config.blank?
  end
  
end
