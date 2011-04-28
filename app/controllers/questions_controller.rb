class QuestionsController < ApplicationController
  before_filter :require_user
  before_filter :current_document
  before_filter :require_active_document, :except => [:destroy, :update]
  
  make_resourceful do
    
    belongs_to :document
    actions :create, :update, :destroy
    
    before :create do
      current_object.user = current_user
    end
    
    before :update do
      @document = current_object.document
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
        redirect_to document_path(current_object.document, :anchor => dom_id(current_object.document_item)) 
      }
      format.js{
        render :partial => 'documents/question', :locals => {:current_object => current_object.document, :question => current_object}
      }
    end
  
    response_for(:create_fails) do |format|
      format.html { 
        session[:previous_question] = current_object.attributes      
        flash[:error] = "We are sorry, but there was a problem asking your question, please try again."
        redirect_to document_path(current_object.document) 
      }
      format.js{
        render :text => "We're sorry your question couldn't be submitted. Please try again.", :status => 500
      }
    end
    
    response_for(:update) do |format|
      format.html {
        flash[:notice] = "Question has been answered successfully, and moved to answered questions."
        redirect_to document_path(current_object.document, :anchor => dom_id(current_object.document_item)) 
      }
      format.js{
        render :partial => 'documents/question', :locals => {:current_object => current_object.document_item.document, :question => current_object}
      }
    end
    
    response_for(:update_fails) do |format|
      format.html {
        flash[:error] = "We are sorry, but there was a problem answering question, please try again."
        redirect_to document_path(current_object.document, :anchor => dom_id(current_object.document_item)) 
      }
    end
    
    response_for(:destroy) do |format|
      format.html{ redirect_to current_object.document }
      format.js{ render :nothing => true}
    end
    

    after :create do
      if params[:question][:send_notifications].to_i == 1
        current_object.notify_document_users        
      end      
    end

  end
  
  private
  
  def current_document
    parent_object
  end
  
end
