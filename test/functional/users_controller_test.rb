require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = User.plan
    @invite = Invitation.make(:recipient_email => @user[:email])
  end

  def login
    activate_authlogic
    UserSession.create(User.make)
  end
 
  def test_should_get_new
    get :new, :invite => @invite.code
    assert_response :success
  end

  def test_should_create_user
    old_count = User.count    
    post :create, :user => User.plan, :invite => @invite.code
    assert_equal old_count + 1, User.count
    
    assert_redirected_to '/'
  end
  
  context "with existing account" do
    setup do
      @user = User.make
    end

    context "showing user" do
      setup do
        login
        get :show, :id => @user.login
      end
      
      should_respond_with :success
    end
    
    context "editing user" do
      setup do
        login
        get :edit, :id => @user.login
      end

      should_respond_with :success
    end
    
    context "updating user" do
      setup do
        login
        put :update, :id => @user.login, :user => { }
      end

      should_redirect_to('user profile') { user_path(@user) }
    end
    
  end

  
end
