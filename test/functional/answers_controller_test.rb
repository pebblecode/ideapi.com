require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  def setup    
    @brief = Brief.make
    @answer = Answer.make(:brief => @brief)
  end
    
  def test_should_get_index
    get :index, :brief_id => @brief.id
    assert_response :success
    assert assigns(:answers)
  end
   
  def test_should_get_new
    get :new, :brief_id => @brief.id
    assert_response :success
  end
   
  def test_should_create_answer
    old_count = Answer.count
    post :create, :answer => Answer.plan(:brief => @brief), :brief_id => @brief.id
    assert_equal old_count + 1, Answer.count
  
    assert_redirected_to brief_answer_path(@brief, assigns(:answer))
  end

  def test_should_show_answer
    get :show, :id => @answer.id, :brief_id => @brief.id
    assert_response :success
  end
   
  def test_should_get_edit
    get :edit, :id => @answer.id, :brief_id => @brief.id
    assert_response :success
  end
   
  def test_should_update_answer
    put :update, :id => @answer.id, :answer => { :body => "Some new body" }, :brief_id => @brief.id
    assert_redirected_to brief_answer_path(@brief, assigns(:answer))
  end
  
  def test_should_destroy_answer
    old_count = Answer.count
    delete :destroy, :id => @answer.id, :brief_id => @brief.id
    assert_equal old_count-1, Answer.count
  
    assert_redirected_to brief_answers_path
  end
end
