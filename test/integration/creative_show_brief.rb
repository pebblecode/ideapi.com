require 'test_helper'

class CreativeShowBrief < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "creative" do
    setup do
      @creative = Creative.make(:password => "testing")
      login_as(@creative)
    
      @brief = Brief.make(:published)
    end
    
    context "show brief" do
      setup do
        visit brief_path(@brief)
      end

      should "see brief details" do
        assert_select 'h2', :text => @brief.title
        assert_contain(@brief.most_important_message)
      end
    end
    
  end
end