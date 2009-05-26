class Section < ActiveRecord::Base
  belongs_to :brief_config
  has_many :section_questions
  has_many :questions, :through => :section_questions
  
  has_simple_ordering
end
