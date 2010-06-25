class QuestionsController < ApplicationController
  before_filter :require_user
  
  before_filter :require_active_brief
  
  make_resourceful do
    
    belongs_to :brief
    actions :create, :update
    
    before :create do
      current_object.user = current_user
    end
    
    before :update do
      if params[:question][:author_answer].present?
        current_object.answered_by = current_user
      end
    end
    
    response_for(:create) do |format|
      format.html { 
        flash[:notice] = "Thanks for joining the discussion."
        redirect_to brief_path(parent_object, :anchor => dom_id(current_object.brief_item)) 
      }
    end
  
    response_for(:create_fails) do |format|
      format.html { 
        session[:previous_question] = current_object.attributes      
        flash[:error] = "We are sorry, but there was a problem asking your question, please try again."
        redirect_to brief_path(parent_object) 
      }
    end
    
    response_for(:update) do |format|
      format.html {
        flash[:notice] = "Question has been answered successfully, and moved to answered questions."
        redirect_to brief_path(parent_object, :anchor => dom_id(current_object.brief_item)) 
      }
    end
    
    response_for(:update_fails) do |format|
      format.html {
        flash[:error] = "We are sorry, but there was a problem answering question, please try again."
        redirect_to brief_path(parent_object, :anchor => dom_id(current_object.brief_item)) 
      }
    end
    
    response_for(:destroy) do |format|
      format.html{ redirect_to session[:return_to] }
    end
    

  end
  
  private
  
  def current_brief
    parent_object
  end
  
end
