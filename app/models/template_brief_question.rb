class TemplateBriefQuestion < ActiveRecord::Base
  belongs_to :template_brief
  belongs_to :template_question

  has_simple_ordering
  
  validates_presence_of :template_brief_id, :template_question_id
  
end
