require 'test_helper'

class BriefCollaborationsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "" do
    setup do
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

      should "description" do
        
      end
    end
    
    
  end

end