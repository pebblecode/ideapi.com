class BriefAnswer < ActiveRecord::Base
  belongs_to :brief
  belongs_to :brief_question
  
  validates_presence_of :answer, :brief, :brief_question
end
