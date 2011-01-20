class CommentsController < ApplicationController
  # needs login for all actions
  before_filter :require_user
  before_filter :store_object, :only => :destroy
  
  make_resourceful do
    belongs_to :document, :proposal
    
    actions :all
    
    before :create do
      current_object.user = current_user
    end
    
    response_for( :create_fails, :update_fails) do |format|
      format.html { redirect_to parent_path(:anchor => dom_id(current_object)) }
      format.js{ render :text => "We're sorry we couldn't submit your comment. Please try again.", :status => 500}
    end
    response_for(:create, :update) do |format|
      format.html { redirect_to parent_path(:anchor => dom_id(current_object)) }
      format.js{
        current_object = nil
        render :partial => 'documents/comment', :locals => {:comment => current_object} 
      }
    end 
        
    response_for(:destroy) do |format|
      format.html{

        flash[:notice] = 'Comment deleted successfully.'
        if @commentable.is_a?(Proposal)
          redirect_to document_proposal_path(@commentable.document, @commentable)
        elsif @commentable.is_a?(Document)
          redirect_to document_path(@commentable)
        else
          redirect_to documents_url
        end
      }
      format.js{ render :json => current_object.to_json}
    end
  end
  
  rescue_from RuntimeError do |exception|
      respond_to do |format|
        format.html{render :text => exception.message, :status => 500}
        format.js{render :text => exception.message, :status => 500}
      end
      # render :text => exception.message, :status => 500
  end
  
  
  def store_object
    @commentable = current_object.commentable
  end
  
  def parent_path(path = nil)
    if parent_object.is_a?(Proposal)
      document_proposal_path(parent_object.document, parent_object)
    else
      document_path(parent_object)
    end
  end
  
  private

  def current_document
    if parent_object.is_a?(Proposal)
      proposal.document
    else
      parent_object
    end
  end

end
