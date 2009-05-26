class BriefSectionBriefQuestion < ActiveRecord::Base
  belongs_to :brief_section
  belongs_to :brief_question
end
