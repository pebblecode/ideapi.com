class BriefAnswer < ActiveRecord::Base
  belongs_to :brief_question
  belongs_to :brief_section
  belongs_to :brief
  has_many :creative_questions
  
  validates_uniqueness_of :brief_question_id, :scope => [:brief_section_id, :brief_id]
  
  validates_presence_of :brief_section_id, :brief_question_id
  
  named_scope :answered, :conditions => "body NOT NULL"
  
  def question
    brief_question.title
  end
  
  class << self
    
    def to_brief_question(brief_question)
      find(:all, :conditions => ["brief_question_id = ?", (brief_question.is_a?(BriefQuestion) ? brief_question.id : brief_question)])
    end
    
  end
end
