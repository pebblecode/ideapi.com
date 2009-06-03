require 'test_helper'

class BriefTemplateTest < ActiveSupport::TestCase

  should_belong_to :brief_config
  should_have_many :brief_sections, :through => :brief_section_brief_templates

end
