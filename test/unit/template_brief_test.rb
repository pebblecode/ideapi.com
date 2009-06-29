require 'test_helper'

class TemplateBriefTest < ActiveSupport::TestCase
  should_have_many :template_brief_questions
  should_have_many :template_questions, :through => :template_brief_questions
end
