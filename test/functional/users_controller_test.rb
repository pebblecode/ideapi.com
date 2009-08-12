require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = User.make
  end

  def login
    activate_authlogic
    UserSession.create(User.make)
  end
  # 
  # def test_should_get_new
  #   get :new
  #   assert_response :success
  # end

  def test_should_create_user
    old_count = User.count
    user = User.plan
    
    post :create, :user => user, :invite => Invitation.make(:recipient_email => user[:email]).code
    assert_equal old_count + 1, User.count
    
    assert_redirected_to '/'
  end
  
  def test_should_show_user
    login
    get :show, :id => @user.id
    assert_response :success
  end
   
  # def test_should_get_edit
  #   login
  #   get :edit, :id => @user.id
  #   assert_response :success
  # end
  # 
  # def test_should_update_user
  #   login
  #   put :update, :id => @user.id, :user => { }
  #   assert_redirected_to user_path(assigns(:user))
  # end
  
end
