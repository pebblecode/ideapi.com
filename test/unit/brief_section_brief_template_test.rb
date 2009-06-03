require 'test_helper'

class BriefSectionBriefTemplateTest < ActiveSupport::TestCase
  should_belong_to :brief_section
  should_belong_to :brief_template
end
