require 'test_helper'

class ApprovalsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  #include ActionView::Helpers::TextHelper
  
  context "" do
    setup do
      @account, @author = user_with_account
      
      @user = @account.users.make(:password => "testing")
      
      @brief = Brief.make(:published, :author => @author, :account => @account)
      populate_brief(@brief)
      
      @proposal = @user.proposals.make(:brief => @brief)
    end

    context "brief author" do
      setup do
        login_to_account_as(@account, @author)
        visit brief_proposal_path(@brief, @proposal)
      end

      should_respond_with :success
      should_render_template :show
      
      should "have access to the proposal" do
        assert_equal(brief_proposal_path(@brief, @proposal), path)
      end
            
    end

  end
  
end
