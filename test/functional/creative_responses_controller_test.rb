require 'test_helper'

class CreativeResponsesControllerTest < ActionController::TestCase

  def setup
    @creative_response = CreativeResponse.make
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
    get :show, :id => @creative_response.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => @creative_response.id
    assert_response :success
  end

  def test_should_update_creative_response
    put :update, :id => @creative_response.id, :creative_response => { }
    assert_redirected_to creative_response_path(assigns(:creative_response))
  end

  def test_should_destroy_creative_response
    old_count = CreativeResponse.count
    delete :destroy, :id => @creative_response.id
    assert_equal old_count-1, CreativeResponse.count

    assert_redirected_to creative_responses_path
  end
end
