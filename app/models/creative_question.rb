class CreativeQuestion < ActiveRecord::Base
  belongs_to :brief_answer
  belongs_to :creative
  
  delegate :brief_section, :to => :brief_answer
  delegate :brief_question, :to => :brief_answer
  
  validates_presence_of :brief_answer, :creative, :body
  
  acts_as_commentable
  acts_as_voteable
  
  named_scope :answered, :conditions => "answer NOT NULL"
  
  def answered?
    !answer.blank?
  end
  
  def love_count
    votes_for
  end
  
  def hate_count
    votes_against
  end
  
end
