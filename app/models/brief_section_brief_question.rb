class BriefSectionBriefQuestion < ActiveRecord::Base
  belongs_to :brief_section
  belongs_to :brief_question
  
  validates_uniqueness_of :brief_question_id, :scope => :brief_section_id 

  def highlighted?
    self.highlighted ? true : false
  end
  
  has_simple_ordering
end
