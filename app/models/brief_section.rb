class BriefSection < ActiveRecord::Base
  belongs_to :brief_config
  has_many :brief_section_brief_questions
  has_many :brief_questions, :through => :brief_section_brief_questions
end
