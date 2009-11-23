require 'test_helper'

class CompletedBriefsTest < ActionController::IntegrationTest

  include BriefWorkflowHelper
  
  context "" do
    setup do
      @account, @user = user_with_account    
      
      @brief = Brief.make(:published, :author => @user, :account => @account)
      
      login_to_account_as(@account, @user)
      visit briefs_path
    end
    
    should "be active" do
      assert @brief.published?
    end
    
    context "setting a brief as completed" do
      setup do
        visit edit_brief_path(@brief)
        click_button 'Mark as complete'
      end
      
      should_respond_with :success
      
      should "now be complete" do
        assert @brief.complete?
      end
      
    end
  
  end

end
