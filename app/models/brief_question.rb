class BriefQuestion < ActiveRecord::Base

  belongs_to :response_type
  has_many :brief_section_brief_questions
  has_many :brief_sections, :through => :brief_section_brief_questions
  
  has_many :brief_answers
  
  def assign_brief_section(brief_section)
    self.brief_sections << brief_section
  end

  alias :assign_brief_section= :assign_brief_section
  
end
