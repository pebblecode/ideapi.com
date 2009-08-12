require 'test_helper'

class InvitationsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "logged in" do
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
        
        setup do
          @valid_emails = 3.times.map { Faker::Internet::email }
        end
        
        context "with valid email addresses" do
          setup do
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
          
          should_respond_with :success
          should_change "Invitation.count", :by => 0
    
        end
        
        context "with mix of valid/invalid email addresses" do
          setup do
            fill_in 'invitation_recipient_list', :with => "bads.food.com, dsadsa@dasda, #{@valid_emails.join(", ")}"
            click_button 'Invite'
          end
          
          should_respond_with :success
          should_change "Invitation.count", :by => 3
    
        end

      end
            
    end
      
  end 
  
  context "" do
    
    setup do
      @invite = Invitation.make
    end
    
    context "visiting valid invite link" do
      setup do
        visit invitation_path(@invite.code)
      end
    
      should_respond_with :success
      
      should "take user to sign up page" do
        assert_equal(new_user_path(:invite => @invite.code), path)
      end
    
    end
    
    context "invalid invite" do
      
      context "visiting invitation path" do
        setup do
          visit invitation_path("imabadasshacker")
        end
    
        should "take user away from signup" do
          assert_equal('/', path)
        end
      end
      
      context "visiting signup path" do
        setup do
          visit new_user_path(:invite => "imabadasshacker")
        end
    
        should "take user away from signup" do
          assert_equal('/', path)
        end
      end
    
    end
    
    context "signup from an invite" do
      setup do
        visit new_user_path(:invite => @invite.code)
      end

      should_respond_with :success
      should_render_template :new

      context "submitting signup form" do
        setup do
          password = "testing"
          
          @user = User.plan(:password => password)
          
          fill_in 'login', :with => @user[:login]
          fill_in 'email', :with => @user[:email]
          
          fill_in 'password', :with => password
          fill_in 'user_password_confirmation', :with => password
          
          click_button 'sign up'
        end
        
        should_respond_with :success
        
        should_change "User.count", :by => 1
        
        should "redeem the invite" do
          assert @invite.reload.accepted?
        end
        
        should "redeem the invite to the new user" do
          user = User.find_by_login(@user[:login])
          assert_equal(user, @invite.reload.redeemed_by) 
        end
        
        should "redirect to sign in" do
          assert_equal(briefs_path, path)
        end
        
      end
    end
    
    
  end 
  
end
