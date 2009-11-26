require 'test_helper'

class BriefCollaborationsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "" do
    setup do
      should_have_template_brief
      
      @account, @author = user_with_account
      @standard_user = User.make(:password => "testing")
      
      @account.users << @standard_user
      
      @published = Brief.make(:published, :author => @author, :account => @account)
      
      populate_brief(@published)
    end
    
    context "brief author" do
      setup do
        login_to_account_as(@account, @author)
        visit brief_path(@published)
        click_link 'Manage users on this brief'
      end
      
      context "removing last author" do
        setup do
          check 'brief_user_briefs_attributes_0__delete'
          click_button 'update'
        end

        should_not_change("Collaborator count") { UserBrief.count }
      end
      
      should "be author" do
        assert @published.authors.include?(@author)
      end
      
      context "revoking write access to the only author" do
        
        setup do
          uncheck 'brief_user_briefs_attributes_0_author'
          click_button 'update'
        end

        should "still be author" do
          assert @published.authors.reload.include?(@author)
        end
        
        should "have errors" do
          assert(@published.errors.on(:user_briefs).present?)
        end
      end
      

    end
    
    
  end

end