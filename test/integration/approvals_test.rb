require 'test_helper'

class ApprovalsTest < ActionController::IntegrationTest
  include DocumentWorkflowHelper
  #include ActionView::Helpers::TextHelper
  
  context "" do
    setup do
      should_have_template_document
      
      @account, @author = user_with_account
      
      @user = @account.users.make(:password => "testing")
      
      @document = Document.make(:published, :author => @author, :account => @account)
      populate_document(@document)
      
      @proposal = @user.proposals.make(:document => @document)
    end

    context "document author" do
      setup do
        login_to_account_as(@account, @author)
        visit document_proposal_path(@document, @proposal)
      end

      should_respond_with :success
      should_render_template :show
      
      should "have access to the proposal" do
        assert_equal(document_proposal_path(@document, @proposal), path)
      end
            
    end

  end
  
end
