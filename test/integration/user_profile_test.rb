require 'test_helper'

class UserProfileTest < ActionController::IntegrationTest
  
  context "creative or author" do
    setup do
      @account, @standard_user = user_with_account    
      login_to_account_as(@account, @standard_user)
    end
    
    context "account page" do
      setup do        
        click_link 'profile'
      end
      
      should_respond_with :success

      should "show email" do
        assert_contain(@standard_user.email)
      end
      
      should "show login" do
        assert_contain(@standard_user.login)
      end
      
    end
    
    context "another users profile" do
      setup do
        @standard_user_2 = @account.users.make(:password => "testing")
        visit user_path(@standard_user_2)
      end
      
      should_respond_with :success
    
      should "show not show email" do
        assert_not_contain(@standard_user_2.email)
      end
      
      should "show login" do
        assert_contain(@standard_user_2.login)
      end
      
      context "when friends" do
        setup do
          @standard_user.become_friends_with(@standard_user_2)
          @standard_user.reload
          reload
        end

        should "show email" do
          assert_contain(@standard_user_2.email)
        end
      end
      
      
    end
    
        
  end
  

end