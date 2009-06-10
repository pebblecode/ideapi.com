class BriefSection < ActiveRecord::Base
  has_many :brief_section_brief_questions
  has_many :brief_questions, :through => :brief_section_brief_questions
  
  has_many :brief_section_brief_templates
  has_many :brief_templates, :through => :brief_section_brief_templates
  
  has_simple_ordering
  
  def assign_brief_template(brief_template)
    self.brief_templates << brief_template
  end
  alias :assign_brief_template= :assign_brief_template
  
  def assign_brief_question(brief_question)
    self.brief_questions << brief_question
  end
  alias :assign_brief_question= :assign_brief_question
  
end
