require 'test_helper'

class CreativeQuestionTest < ActiveSupport::TestCase
  should_belong_to :creative
  should_belong_to :brief
end
