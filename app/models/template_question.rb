class TemplateQuestion < ActiveRecord::Base
  has_many :template_brief_questions
  has_many :template_briefs, :through => :template_brief_questions
  belongs_to :template_section

  def section_name
    template_section.title
  end

end
