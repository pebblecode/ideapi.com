require 'test_helper'

class AccountAdministrationTest < ActionController::IntegrationTest
  
  include ActionView::Helpers::TextHelper
  
  context "An account owner" do
    setup do
      should_have_template_document
      
      @user = User.make(:password => "testing")
      @account = Account.make(:user => @user, :plan => SubscriptionPlan.make(:basic))
      @premium_account = SubscriptionPlan.make(:premium)
       
      login_to_account_as(@account, @user)
    end

    # should "have link to account" do
    #   assert_select 'a[href=?]', account_path, :text => 'account'
    # end
    
    # On the beta, we are not showing account link ..
    should "have not have an account link" do
      assert_select 'a[href=?]', account_path, :text => 'account', :count => 0
    end
    
    context "account page" do
      setup do
        visit account_path
      end
      
      should_respond_with :success
      should_render_template :show
      
      context "billing" do
        # Disabled during beta
        #should "have payment details" do
        #  assert_contain("Payment details")
        #end
        
        #should "tell user when their next payment date is" do
        #  assert_contain(@account.subscription.next_renewal_at.to_s(:long_day))
        #end
      end      
      
      context "trial" do
        #should "tell user when their trial finishes" do
        #  assert_contain(@account.subscription.next_renewal_at.to_s(:long_day))
        #end
        
        #should "tell user how many days they have left" do
        #  assert_contain(pluralize(@account.subscription.trial_days, 'day', 'days'))
        #end
      end

      should "have plan changing section" do
        # assert_contain('Your plan')
      end
      
      context "changing plan" do
        setup do          
          #choose "plan_id_#{@premium_account.id}"
          # click_button 'Change plan subscription'
        end
        
        should "now be subscribed to premium account" do
          # assert_equal(@premium_account, @account.reload.subscription.subscription_plan)
        end
      end
      
      should "have link to cancel account" do
        # assert_select 'a[href=?]', cancel_account_url, :text => 'Cancel plan'
      end
      
      context "cancel account page" do
        setup do
          # click_link 'Cancel plan'
        end

        should "take user to cancel account page" do
          # assert_equal(cancel_account_path, path)
        end
        
        should "have link to change subscription plan" do
          # assert_contain 'Change your subscription level now.'
        end
        
        context "agreeing to cancel account" do
          setup do
            # check 'confirm'
            # click_button 'Delete my Account'
          end

          # should respond_with :success
          # should_render_template :cancelled
          should "change the number of accounts from 1 to 0" do
            # assert_equal 0, Account.count
          end
        end
        
        
      end
      
      
    end
    
    
    context "account limits" do
      setup do
        @user_limit = 5
        @account.subscription.update_attribute(:user_limit, @user_limit)
      end
      
      should "have a user limit" do
        assert_equal(@user_limit, @account.user_limit)
      end
      
    end
    
    
  end
  
  
end
