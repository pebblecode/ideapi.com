class TemplateBrief < ActiveRecord::Base
  belongs_to :site
  has_many :template_brief_questions
  has_many :template_questions, :through => :template_brief_questions
end
