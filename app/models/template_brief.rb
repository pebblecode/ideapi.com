class TemplateBrief < ActiveRecord::Base
  belongs_to :site
  has_many :template_brief_questions
  has_many :template_questions, :through => :template_brief_questions, :order => :template_section_id

  accepts_nested_attributes_for :template_brief_questions, 
    :allow_destroy => true
    
  

end
