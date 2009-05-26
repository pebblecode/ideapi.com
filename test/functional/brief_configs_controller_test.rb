require File.dirname(__FILE__) + '/../test_helper'
require 'brief_configs_controller'

# Re-raise errors caught by the controller.
class BriefConfigsController; def rescue_action(e) raise e end; end

class BriefConfigsControllerTest < Test::Unit::TestCase
  fixtures :brief_configs

  def setup
    @controller = BriefConfigsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
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
    post :create, :brief_config => { }
    assert_equal old_count + 1, BriefConfig.count

    assert_redirected_to brief_config_path(assigns(:brief_config))
  end

  def test_should_show_brief_config
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_brief_config
    put :update, :id => 1, :brief_config => { }
    assert_redirected_to brief_config_path(assigns(:brief_config))
  end

  def test_should_destroy_brief_config
    old_count = BriefConfig.count
    delete :destroy, :id => 1
    assert_equal old_count-1, BriefConfig.count

    assert_redirected_to brief_configs_path
  end
end
