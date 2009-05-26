require 'test_helper'

class BriefsControllerTest < ActionController::TestCase

  def setup
    @brief = Brief.make
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
    post :create, :brief => Brief.plan
    assert_equal old_count + 1, Brief.count
  
    assert_redirected_to brief_path(assigns(:brief))
  end
  
  def test_should_show_brief
    get :show, :id => @brief.id
    assert_response :success
  end
  
  def test_should_get_edit
    get :edit, :id => @brief.id
    assert_response :success
  end
  
  def test_should_update_brief
    put :update, :id => @brief.id, :brief => { :title => "Title update" }
    assert_redirected_to brief_path(assigns(:brief))
  end
  
  def test_should_destroy_brief
    old_count = Brief.count
    delete :destroy, :id => @brief.id
    assert_equal old_count-1, Brief.count
  
    assert_redirected_to briefs_path
  end
end
