require 'test_helper'

class InvitationsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "" do
    setup do
      @user = User.make(:password => "testing")
      login_as(@user)
    end
    
    context "the dashboard" do
      setup do
        visit briefs_path
      end

      should "contain an invitation form" do
        assert_select 'form[action=?]', invitations_path 
      end
    
      
      context "filling in invitations" do
        
        context "with valid email addresses" do
          setup do
            @valid_emails = 3.times.map { Faker::Internet::email }
            fill_in 'invitation_recipient_list', :with => @valid_emails.join(", ")
            click_button 'Invite'
          end

          should_respond_with :success          
          should_change "Invitation.count", :by => 3
          
        end
        
        context "with invalid email addresses" do
          setup do
            fill_in 'invitation_recipient_list', :with => "bads.food.com, dsadsa@dasda"
            click_button 'Invite'
          end
          
        end
        
        
      end
      
      
    end
      
  end  
  
end
