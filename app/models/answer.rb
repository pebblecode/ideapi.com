class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :brief
  
  class << self
    
    def to_question(question)
      find(:all, :conditions => ["question_id = ?", (question.is_a?(Question) ? question.id : question)])
    end
    
  end
  
end
