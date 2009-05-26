class BriefQuestion < ActiveRecord::Base
  belongs_to :response_type
  has_many :brief_section_brief_questions
  has_many :brief_sections, :through => :brief_section_brief_questions
  validates_presence_of :title, :response_type
end
