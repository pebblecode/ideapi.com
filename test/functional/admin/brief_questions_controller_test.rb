require 'test_helper'

class Admin::BriefQuestionsControllerTest < ActionController::TestCase

  def setup
    @brief_question = BriefQuestion.make
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
  
    assert_redirected_to admin_brief_question_path(assigns(:brief_question))
  end
  
  def test_should_show_brief_question
    get :show, :id => @brief_question.id
    assert_response :success
  end
  
  def test_should_get_edit
    get :edit, :id => @brief_question.id
    assert_response :success
  end
  
  def test_should_update_brief_question
    put :update, :id => @brief_question.id, :brief_question => { }
    assert_redirected_to admin_brief_question_path(assigns(:brief_question))
  end
  
  def test_should_destroy_brief_question
    old_count = BriefQuestion.count
    delete :destroy, :id => @brief_question.id
    assert_equal old_count-1, BriefQuestion.count
  
    assert_redirected_to admin_brief_questions_path
  end
end
