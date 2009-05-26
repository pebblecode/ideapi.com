require File.dirname(__FILE__) + '/../test_helper'
require 'creative_responses_controller'

# Re-raise errors caught by the controller.
class CreativeResponsesController; def rescue_action(e) raise e end; end

class CreativeResponsesControllerTest < Test::Unit::TestCase
  fixtures :creative_responses

  def setup
    @controller = CreativeResponsesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:creative_responses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_creative_response
    old_count = CreativeResponse.count
    post :create, :creative_response => { }
    assert_equal old_count + 1, CreativeResponse.count

    assert_redirected_to creative_response_path(assigns(:creative_response))
  end

  def test_should_show_creative_response
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_creative_response
    put :update, :id => 1, :creative_response => { }
    assert_redirected_to creative_response_path(assigns(:creative_response))
  end

  def test_should_destroy_creative_response
    old_count = CreativeResponse.count
    delete :destroy, :id => 1
    assert_equal old_count-1, CreativeResponse.count

    assert_redirected_to creative_responses_path
  end
end
