require 'test_helper'

class AccountUserManagementTest < ActionController::IntegrationTest
  
  context "an an account owner" do
    setup do
      should_have_template_document
      
      @user_limit = 5
      
      @user = User.make(:password => "testing")
      @account = Account.make(:user => @user, :plan => SubscriptionPlan.make(:basic, :user_limit => @user_limit))
      
      login_to_account_as(@account, @user)
    end
    
    context "contacts page" do
      setup do
        click_link 'contacts'
      end

      should_respond_with :success
      should_render_template :index
      
      should "have form to invite users" do
        assert_select 'form[action=?]', users_path
      end
      
      context "inviting a user that doesnt have an account" do
        setup do
          @invite = User.plan
          fill_in 'First name', :with => @invite[:first_name]
          fill_in 'Last name', :with => @invite[:last_name]
          fill_in 'Email', :with => @invite[:email]
          
          click_button 'Add to account'
        end
        
        should_respond_with :success
        
        should_change "User.pending.count", :by => 1
        should_change "AccountUser.count", :by => 1
        
        should "mark invited by current_user" do
          assert_equal(@user, User.find_by_email(@invite[:email]).invited_by)
        end
        
        should "send out email to user" do
          assert_sent_email do |email|
            email.subject == "[#{@account.name} ideapi] You have been invited to an account on ideapi.com"
            email.body =~ /#{@account.full_domain}\/users\/signup\/#{@user.invite_code}/
          end
        end
        
      end
      
      context "adding an existing user to the account" do
        setup do
          @invite = User.make
          fill_in 'First name', :with => @invite[:first_name]
          fill_in 'Last name', :with => @invite[:last_name]
          fill_in 'Email', :with => @invite[:email]
          click_button 'Add to account'
        end
        
        should_change "AccountUser.count", :by => 1
        
        context "adding them again" do
          setup do
            fill_in 'First name', :with => @invite[:first_name]
            fill_in 'Last name', :with => @invite[:last_name]
            fill_in 'Email', :with => @invite[:email]
            click_button 'Add to account'            
          end
          
          should_not_change "AccountUser.count"
        end        
      
      end  
      
    end
    
  end
  
end
