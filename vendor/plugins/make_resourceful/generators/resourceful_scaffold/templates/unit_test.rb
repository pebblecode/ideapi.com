require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../test_helper'

class <%= class_name %>Test < ActiveSupport::TestCase
  def test_truth
    assert true
  end
end
