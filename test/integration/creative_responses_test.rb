require 'test_helper'

class CreativeResponsesTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  include ActionView::Helpers::TextHelper

  context "" do
    setup do
      @author = User.make(:password => "testing")
      @standard_user = User.make(:password => "testing")      
      @brief = Brief.make(:published, :user => @author)
      populate_brief(@brief)    
    end
    
    context "submitting a creative response" do
      setup do
        visit brief_path(@brief)
      end
            
      context "when viewing a brief" do
        should "have link to create a response" do
          assert_select 'a[href=?]', new_brief_proposal(@brief), 
            :text => 'Draft response'
        end
      end
    
    end
    
  end

end
