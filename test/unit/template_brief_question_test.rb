require 'test_helper'

class TemplateBriefQuestionTest < ActiveSupport::TestCase
  should_belong_to :template_brief
  should_belong_to :template_question
end
