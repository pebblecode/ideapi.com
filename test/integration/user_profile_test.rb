require 'test_helper'

class UserProfileTest < ActionController::IntegrationTest
  
  context "creative or author" do
    setup do
      @standard_user = User.make(:password => "testing")
      login_as(@standard_user)
    end
    
    context "account page" do
      setup do
        click_link 'my account'
      end
      
      should_respond_with :success
      
      should "address current user as you" do
        assert_contain("You")
      end
      
    end
    
    context "another users profile" do
      setup do
        @standard_user_2 = User.make(:password => "testing")
        visit user_path(@standard_user_2)
      end
      
      should_respond_with :success
      
      should "address current user as you" do
        assert_contain(@standard_user_2.login.titleize)
      end
      
    end
    
        
  end
  

end