require File.dirname(__FILE__) + '/../test_helper'
require 'brief_questions_controller'

# Re-raise errors caught by the controller.
class BriefQuestionsController; def rescue_action(e) raise e end; end

class BriefQuestionsControllerTest < Test::Unit::TestCase
  fixtures :brief_questions

  def setup
    @controller = BriefQuestionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:brief_questions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_brief_question
    old_count = BriefQuestion.count
    post :create, :brief_question => { }
    assert_equal old_count + 1, BriefQuestion.count

    assert_redirected_to brief_question_path(assigns(:brief_question))
  end

  def test_should_show_brief_question
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_brief_question
    put :update, :id => 1, :brief_question => { }
    assert_redirected_to brief_question_path(assigns(:brief_question))
  end

  def test_should_destroy_brief_question
    old_count = BriefQuestion.count
    delete :destroy, :id => 1
    assert_equal old_count-1, BriefQuestion.count

    assert_redirected_to brief_questions_path
  end
end
