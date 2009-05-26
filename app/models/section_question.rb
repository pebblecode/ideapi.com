class SectionQuestion < ActiveRecord::Base
  belongs_to :section
  belongs_to :question
  
  has_simple_ordering
end
