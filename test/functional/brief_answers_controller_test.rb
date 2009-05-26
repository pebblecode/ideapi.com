require File.dirname(__FILE__) + '/../test_helper'
require 'brief_answers_controller'

# Re-raise errors caught by the controller.
class BriefAnswersController; def rescue_action(e) raise e end; end

class BriefAnswersControllerTest < Test::Unit::TestCase
  fixtures :brief_answers

  def setup
    @controller = BriefAnswersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:brief_answers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_brief_answer
    old_count = BriefAnswer.count
    post :create, :brief_answer => { }
    assert_equal old_count + 1, BriefAnswer.count

    assert_redirected_to brief_answer_path(assigns(:brief_answer))
  end

  def test_should_show_brief_answer
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_brief_answer
    put :update, :id => 1, :brief_answer => { }
    assert_redirected_to brief_answer_path(assigns(:brief_answer))
  end

  def test_should_destroy_brief_answer
    old_count = BriefAnswer.count
    delete :destroy, :id => 1
    assert_equal old_count-1, BriefAnswer.count

    assert_redirected_to brief_answers_path
  end
end
