class TemplateBriefQuestion < ActiveRecord::Base
  belongs_to :template_brief
  belongs_to :template_question
end
