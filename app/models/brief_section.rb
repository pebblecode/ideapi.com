class BriefSection < ActiveRecord::Base
  has_many :brief_section_brief_questions
  has_many :brief_questions, :through => :brief_section_brief_questions
  
  has_many :brief_section_brief_templates
  has_many :brief_templates, :through => :brief_section_brief_templates
  

  has_simple_ordering
end
