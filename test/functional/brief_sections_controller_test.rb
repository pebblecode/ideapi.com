require File.dirname(__FILE__) + '/../test_helper'
require 'brief_sections_controller'

# Re-raise errors caught by the controller.
class BriefSectionsController; def rescue_action(e) raise e end; end

class BriefSectionsControllerTest < Test::Unit::TestCase
  fixtures :brief_sections

  def setup
    @controller = BriefSectionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:brief_sections)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_brief_section
    old_count = BriefSection.count
    post :create, :brief_section => { }
    assert_equal old_count + 1, BriefSection.count

    assert_redirected_to brief_section_path(assigns(:brief_section))
  end

  def test_should_show_brief_section
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_brief_section
    put :update, :id => 1, :brief_section => { }
    assert_redirected_to brief_section_path(assigns(:brief_section))
  end

  def test_should_destroy_brief_section
    old_count = BriefSection.count
    delete :destroy, :id => 1
    assert_equal old_count-1, BriefSection.count

    assert_redirected_to brief_sections_path
  end
end
