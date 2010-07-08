
require 'test_helper'

class ManageTemplatesTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "Managing Templates" do
    setup do
      should_have_template_brief
      
      @account, @user = user_with_account    
    end
    
    context "as a user who can create briefs" do
      setup do
        login_to_account_as(@account, @user)
        visit dashboard_path
      end

      should "show a link to the dashboard" do
        assert_contain("dashboard")
      end

    end
     
  end
  
end
