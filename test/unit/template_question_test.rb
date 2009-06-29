require 'test_helper'

class TemplateQuestionTest < ActiveSupport::TestCase
  should_have_many :template_brief_questions
  should_have_many :template_briefs, :through => :template_brief_questions
end
