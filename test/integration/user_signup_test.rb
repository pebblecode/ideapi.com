require 'test_helper'

class UserSignupTest < ActionController::IntegrationTest
  
  context "an an account owner" do
    setup do
      @account = Account.make(:user => User.make, :plan => SubscriptionPlan.make(:basic, :user_limit => @user_limit))
      @account.users << User.make(:stubbed)
    end
  end
end
