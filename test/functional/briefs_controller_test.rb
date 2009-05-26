require File.dirname(__FILE__) + '/../test_helper'
require 'briefs_controller'

# Re-raise errors caught by the controller.
class BriefsController; def rescue_action(e) raise e end; end

class BriefsControllerTest < Test::Unit::TestCase
  fixtures :briefs

  def setup
    @controller = BriefsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:briefs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_brief
    old_count = Brief.count
    post :create, :brief => { }
    assert_equal old_count + 1, Brief.count

    assert_redirected_to brief_path(assigns(:brief))
  end

  def test_should_show_brief
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_brief
    put :update, :id => 1, :brief => { }
    assert_redirected_to brief_path(assigns(:brief))
  end

  def test_should_destroy_brief
    old_count = Brief.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Brief.count

    assert_redirected_to briefs_path
  end
end
