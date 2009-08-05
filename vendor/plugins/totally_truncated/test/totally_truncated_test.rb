require 'test_helper'

class TotallyTruncatedTest < ActiveSupport::TestCase

  setup do
    @boom = Boom.new
  end

  test "creates instance methods" do
    assert @boom.respond_to?(:explode_truncated)
  end

end
