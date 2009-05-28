class SectionQuestion < ActiveRecord::Base
  belongs_to :section
  belongs_to :question
  
  validates_uniqueness_of :question_id, :scope => :section_id 

  def highlighted?
    self.highlighted ? true : false
  end
  
  has_simple_ordering
end
