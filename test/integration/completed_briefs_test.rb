require 'test_helper'

class CompletedBriefsTest < ActionController::IntegrationTest

  include BriefWorkflowHelper
  
  context "" do
    setup do
      should_have_template_brief
      
      @account, @user = user_with_account    
      
      @brief = Brief.make(:author => @user, :account => @account)
      
      login_to_account_as(@account, @user)
      
      visit edit_brief_path(@brief)
    end
    
    context "draft brief" do
      # https://abutcher.lighthouseapp.com/projects/32755/tickets/41-bug-reactive-button-visible
      
      should "not have link to Reactivate" do
        assert_select 'input[type=submit][value=?]', 'Reactivate', :count => 0
      end
      
    end
    
    
    context "published brief" do
      
      setup do
        click_button 'publish'
      end
      
      should "be active" do
        assert @brief.reload.published?
      end
      
      context "setting a brief as completed" do
        
        setup do
          visit edit_brief_path(@brief)
        end
        
        should "have button to mark as complete" do
          assert_select 'input[type=submit][value=?]', 'Mark as complete', :count => 1
        end
        
        context "clicking mark as complete" do
          setup do
            click_button 'Mark as complete'
          end

          should_respond_with :success

          should "now be complete" do
            assert @brief.reload.complete?
          end
        end

      end
      
    end
  
  end

end
