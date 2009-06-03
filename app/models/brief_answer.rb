class BriefAnswer < ActiveRecord::Base
  belongs_to :brief_question
  belongs_to :brief_section
  belongs_to :brief
  
  validates_uniqueness_of :brief_question_id, :scope => [:brief_section_id, :brief_id]
  
  class << self
    
    def to_brief_question(brief_question)
      find(:all, :conditions => ["brief_question_id = ?", (brief_question.is_a?(BriefQuestion) ? brief_question.id : brief_question)])
    end
    
  end
end
