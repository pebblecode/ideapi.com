class BriefItem < ActiveRecord::Base
  belongs_to :brief
  belongs_to :template_question
  
  has_many :creative_questions
  
  validates_presence_of :brief, :template_question, :on => :create, :message => "can't be blank"
  
  delegate :optional, :to => :template_question
  delegate :help_message, :to => :template_question
  delegate :section_name, :to => :template_question
  
  named_scope :answered, :conditions => 'body <> ""'
  
  def has_history?
    !creative_questions.answered.blank?
  end
  
end
