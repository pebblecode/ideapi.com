require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = User.make
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_user
    old_count = User.count
    post :create, :user => User.plan
    assert_equal old_count + 1, User.count
  
    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_show_user
     get :show, :id => @user.id
     assert_response :success
  end
  
   def test_should_get_edit
     get :edit, :id => @user.id
     assert_response :success
   end
  
   def test_should_update_user
     put :update, :id => @user.id, :user => { }
     assert_redirected_to user_path(assigns(:user))
   end
 
end
