class BriefItem < ActiveRecord::Base
  belongs_to :brief
  belongs_to :template_question
  
  validates_presence_of :brief, :template_question, :on => :create, :message => "can't be blank"
  
  delegate :optional, :to => :template_question
  delegate :help_message, :to => :template_question
  
  named_scope :answered, :conditions => "body IS NULL"
  
end
