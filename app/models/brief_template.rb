class BriefTemplate < ActiveRecord::Base
  belongs_to :brief_config
  
  has_many :brief_section_brief_templates
  has_many :brief_sections, :through => :brief_section_brief_templates
end
