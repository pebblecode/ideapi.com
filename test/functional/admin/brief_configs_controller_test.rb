require 'test_helper'

class Admin::BriefConfigsControllerTest < ActionController::TestCase

  def setup
    # activate_authlogic
#    UserSession.create(@user)
    @brief_config = BriefConfig.make
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:brief_configs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_brief_config
    old_count = BriefConfig.count
    post :create, :brief_config => BriefConfig.plan
    assert_equal old_count + 1, BriefConfig.count
  
    assert_redirected_to admin_brief_config_path(assigns(:brief_config))
  end
  
  def test_should_show_brief_config
    get :show, :id => @brief_config.id
    assert_response :success
  end
  
  def test_should_get_edit
    get :edit, :id => @brief_config.id
    assert_response :success
  end
  
  def test_should_update_brief_config
    put :update, :id => @brief_config.id, :brief_config => { }
    assert_redirected_to admin_brief_config_path(assigns(:brief_config))
  end
  
  def test_should_destroy_brief_config
    old_count = BriefConfig.count
    delete :destroy, :id => @brief_config.id
    assert_equal old_count-1, BriefConfig.count
  
    assert_redirected_to admin_brief_configs_path
  end
end
