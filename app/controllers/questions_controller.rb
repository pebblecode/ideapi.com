class QuestionsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  before_filter :require_user
  helper_method :brief_items, :record_author?
    
  def current_objects
    @current_objects ||= (
      if params[:brief_item_id]
        
        if params[:brief_item_id].blank?
          redirect_to brief_questions_path(parent_object, :f => 'recent')
        else
          parent_object.questions.find_all_by_brief_item_id(params[:brief_item_id])
        end
        
      else
        reset_filter(params[:f])
        parent_object.questions.send(@current_filter)
      end
    )
  end
  
  make_resourceful do
    
    belongs_to :brief
    
    before :index do
      add_breadcrumb 'dashboard', "/dashboard"
      add_breadcrumb truncate(parent_object.title.downcase, :length => 30), brief_path(parent_object)      
      add_breadcrumb 'discussion', objects_path
      
      @brief_item = BriefItem.find(params[:brief_item_id]) if !params[:brief_item_id].blank?
      @user_question ||= parent_object.questions.build(session[:previous_question])
      
      @user_question.valid?
    end
    
    before :create do
      current_object.user = current_user
    end
    
    after :create do
      current_user.watch(parent_object)
    end
    
    response_for(:index) do |format|
      format.html
      format.js { render :action => 'ask_question', :layout => false }
    end
    
    response_for(:create) do |format|
      format.html { 
        flash[:notice] = "Thanks for joining the discussion."
        redirect_to brief_questions_path(parent_object, :f => 'recent') 
      }
    end
  
    response_for(:create_fails) do |format|
      format.html { 
        session[:previous_question] = current_object.attributes
              
        flash[:error] = "We are sorry, but there was a problem asking your question, please try again."
        redirect_to brief_questions_path(parent_object, :f => 'unanswered') 
      }
    end
    
    response_for(:update) do |format|
      format.html {
        flash[:notice] = "Question has been answered successfully, and moved to answered questions."
        redirect_to brief_questions_path(parent_object, :f => 'unanswered') 
      }
    end
    
    response_for(:update_fails) do |format|
      format.html {
        flash[:error] = "We are sorry, but there was a problem updating question, please try again."
        redirect_to brief_questions_path(parent_object, :f => 'unanswered') 
      }
    end

    belongs_to :brief
    actions :all
  end
  
  private
  
  def brief_items
    @brief_answers = parent_object.brief_items.answered
  end
  
  def record_author?
    parent_object.user == current_user
  end
  
  def reset_filter(question_filter)
    @current_objects = nil if @current_filter != question_filter
    @current_filter = question_filter || "recent"
  end
  
end
