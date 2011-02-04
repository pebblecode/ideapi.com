require 'test_helper'

class ManageTemplatesTest < ActionController::IntegrationTest
  include DocumentWorkflowHelper
  
  context "Managing Templates" do
    setup do
      should_have_template_document
      
      @account, @user = user_with_account    
    end
    
    context "as a user who can create documents" do
      setup do
        login_to_account_as(@account, @user)
        visit documents_path
      end

      should "show a link to the documents" do
        assert_contain("documents")
      end

    end
     
  end
  
end
