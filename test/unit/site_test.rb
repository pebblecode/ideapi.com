require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  should_have_many :briefs
  should_have_many :template_briefs
end
