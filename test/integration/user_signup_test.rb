require 'test_helper'

class UserSignupTest < ActionController::IntegrationTest
  
  context "an an account owner" do
    setup do
      @account = Account.make(:user => User.make, :plan => SubscriptionPlan.make(:basic, :user_limit => @user_limit))      
      @user_stubbed = User.make(:stubbed)
      @account.users << @user_stubbed
      
      # stub extra details to fill in
      @user_details = User.plan      
      
      visit user_signup_url(:invite_code => @user_stubbed.invite_code, :host => @account.full_domain)    
    end
    
    context "filling in required attributes" do
      setup do
        fill_in 'Screename', :with => @user_details[:screename]     
        fill_in 'Password', :with => @user_details[:password]
        fill_in 'Password confirmation', :with => @user_details[:password]
        
        click_button "Complete registration"
      end

      should "redirect to dashboard" do
        assert_equal(dashboard_path, path)
      end
      
      should "now be active" do
        assert @user_stubbed.reload.active?
      end
      
      should "now remove invite code" do
        assert @user_stubbed.reload.invite_code.blank?
      end
    end
    
    context "not filling in required attributes" do
      setup do
        fill_in 'Password', :with => @user_details[:password]
        fill_in 'Password confirmation', :with => @user_details[:password]
                
        click_button "Complete registration"
      end

      should "have errors on login" do
        assert_select '.field_with_errors input[name=?]', "user[screename]"
      end
      
      should "still be pending" do
        assert @user_stubbed.reload.pending?
      end
    end
    
  end
end
