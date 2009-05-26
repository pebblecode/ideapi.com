class SectionQuestion < ActiveRecord::Base
  belongs_to :section
  belongs_to :question
  
  validates_uniqueness_of :question_id, :scope => :section_id 
  
  has_simple_ordering
end
