require 'test_helper'

class CreativeShowBrief < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "creative" do
    setup do
      @creative = Creative.make(:password => "testing")
      login_as(@creative)
    
      @brief = Brief.make(:published)
      populate_brief(@brief)
    end
    
    context "show brief" do
      setup do
        visit brief_path(@brief)
      end

      should "see brief details" do
        assert_select 'h2', :text => @brief.title
        assert_contain(@brief.most_important_message)
      end
         
      context "answered questions" do
        setup do
          @author = @brief.author
          @creative = Creative.make
        end

        should "appear within the brief document" do          
          check_for_questions(@brief, @creative)
        end
      end  
    
    end    
    
  end
end