require 'test_helper'

class UserProfileTest < ActionController::IntegrationTest
  
  context "creative or author" do
    setup do
      @creative = Creative.make(:password => "testing")
      login_as(@creative)
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
        @creative_2 = Creative.make(:password => "testing")
        visit user_path(@creative_2)
      end
      
      should_respond_with :success
      
      should "address current user as you" do
        assert_contain(@creative_2.login.titleize)
      end
      
    end
    
        
  end
  

end