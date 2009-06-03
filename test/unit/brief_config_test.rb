require 'test_helper'

class BriefConfigTest < ActiveSupport::TestCase
  
  context "valid brief config" do
    setup do
      @brief_config = BriefConfig.make
    end
    
    should_have_many :brief_templates
    
    should_validate_presence_of :title
    should_validate_uniqueness_of :title
    
    should "be valid" do
      @brief_config.valid?
    end
  end
  
  context "Current config" do
    setup do
      @brief_config = BriefConfig.make
    end

    should "get current" do
      assert BriefConfig.respond_to?(:current)
      assert_equal(@brief_config, BriefConfig.current)
    end
  end
  
  
end
