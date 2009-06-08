class CreativeQuestionsController < ApplicationController
  before_filter :require_creative, :except => [:index, :show]
  
  before_filter :brief
  helper_method :brief
  
  def current_objects
    @current_objects ||= CreativeQuestion.all(:conditions => ["brief_answer_id IN (?)", brief.brief_answer_ids], :order => "created_at DESC")
  end
  
  make_resourceful do
    actions :all
    
    before :index do
      mock_question
      brief_answers
    end
    
    before :create do
      current_object.creative = current_user
    end
    
    response_for :create do
      redirect_to_brief_questions
    end
    
    response_for :create_fails do
      brief_answers
      mock_question
      render :action => :index
    end
    
  end
  
  def love
    current_user.vote_for(current_object) if !current_user.voted_for?(current_object)
    redirect_to_brief_questions
  end
  
  def hate
    current_user.vote_against(current_object) if !current_user.voted_against?(current_object)
    redirect_to_brief_questions
  end
  
  private
  
  def brief_answers
    @brief_answers ||= BriefAnswer.find(brief.brief_answer_ids)
  end
  
  def mock_question
    @new_question ||= current_model.new(:brief_answer_id => params[:response_to])
  end
  
  def brief
    @brief ||= Brief.find(params[:brief_id])
  end
  
  def redirect_to_brief_questions
    redirect_to brief_creative_questions_path(brief) << "#creative_question_#{current_object.id}"
  end
end
