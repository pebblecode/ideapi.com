require 'test_helper'

class Admin::QuestionsControllerTest < ActionController::TestCase

  def setup
    @question = Question.make
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:questions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_question
    old_count = Question.count
    post :create, :question => { }
    assert_equal old_count + 1, Question.count
  
    assert_redirected_to admin_question_path(assigns(:question))
  end
  
  def test_should_show_question
    get :show, :id => @question.id
    assert_response :success
  end
  
  def test_should_get_edit
    get :edit, :id => @question.id
    assert_response :success
  end
  
  def test_should_update_question
    put :update, :id => @question.id, :question => { }
    assert_redirected_to admin_question_path(assigns(:question))
  end
  
  def test_should_destroy_question
    old_count = Question.count
    delete :destroy, :id => @question.id
    assert_equal old_count-1, Question.count
  
    assert_redirected_to admin_questions_path
  end
end
