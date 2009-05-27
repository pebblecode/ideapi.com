class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :section
  belongs_to :brief
  
  validates_uniqueness_of :question_id, :scope => [:section_id, :brief_id]
  
  class << self
    
    def to_question(question)
      find(:all, :conditions => ["question_id = ?", (question.is_a?(Question) ? question.id : question)])
    end
    
  end
  
end
