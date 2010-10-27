class QuestionsController < ApplicationController
  before_filter :require_user
  before_filter :current_brief
  before_filter :require_active_brief, :except => [:destroy, :update]
  
  make_resourceful do
    
    belongs_to :brief
    actions :create, :update, :destroy
    
    before :create do
      current_object.user = current_user
    end
    
    before :update do
      if params[:question][:author_answer].present?
        current_object.answered_by = current_user
      else
        params[:question][:author_answer] = nil
        current_object.answered_by = nil
      end
    end
    
    response_for(:create) do |format|
      format.html { 
        flash[:notice] = "Thanks for joining the discussion."
        redirect_to brief_path(current_object.brief, :anchor => dom_id(current_object.brief_item)) 
      }
      format.js{
        render :partial => 'briefs/question', :locals => {:current_object => current_object.brief, :question => current_object}
      }
    end
  
    response_for(:create_fails) do |format|
      format.html { 
        session[:previous_question] = current_object.attributes      
        flash[:error] = "We are sorry, but there was a problem asking your question, please try again."
        redirect_to brief_path(current_object.brief) 
      }
      format.js{
        render :text => "We're sorry your question couldn't be submitted. Please try again.", :status => 500
      }
    end
    
    response_for(:update) do |format|
      format.html {
        flash[:notice] = "Question has been answered successfully, and moved to answered questions."
        redirect_to brief_path(current_object.brief, :anchor => dom_id(current_object.brief_item)) 
      }
      format.js{
        render :partial => 'briefs/question', :locals => {:current_object => current_object.brief_item.brief, :question => current_object}
      }
    end
    
    response_for(:update_fails) do |format|
      format.html {
        flash[:error] = "We are sorry, but there was a problem answering question, please try again."
        redirect_to brief_path(current_object.brief, :anchor => dom_id(current_object.brief_item)) 
      }
    end
    
    response_for(:destroy) do |format|
      format.html{ redirect_to current_object.brief }
      format.js{ render :nothing => true}
    end
    

  end
  
  private
  
  def current_brief
    parent_object
  end
  
end
