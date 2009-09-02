require 'test_helper'

class FriendshipRequestTest < ActionController::IntegrationTest
  
  context "responding to a friend request" do
    setup do
      @user = User.make(:login => "frank_longe", :password => "testing")
      @friend = User.make(:password => "testing")
            
      @friendship, @status = @user.be_friends_with(@friend)      
    
      visit(friendship_path(@friendship))
    end
    
    should "require login" do
      assert_equal(new_user_session_path, path)
    end
    
    context "logging in" do
      setup do
        login_as(@friend)
      end

      should "take user to friend path" do
        assert_equal(friendship_path(@friendship), path)
      end
      
      context "friendship request form" do
        
        should "have link to friendship request senders profile" do          
          assert_select 'a[href=?]', user_path(@user), 
            :text => @user.login.capitalize
        end
        
        context "clicking on accept" do
          setup do
            click_button 'accept'
          end

          should_respond_with :success
          
          should "redirect to profile path" do
            assert_equal(user_path(@friend), path)
          end
          
          should_set_the_flash_to(
            { :notice => "You are now contacts with frank_longe" }
          )
          
          context "user" do
            should "be friends with friend" do
              assert @friend.reload.friends?(@user)
            end
          end
          
          context "friend" do
            should "be friends with user" do
              assert @user.reload.friends?(@friend)
            end
          end
          
        end
        
        
      end
      
      
    end

  end
  
  
end
