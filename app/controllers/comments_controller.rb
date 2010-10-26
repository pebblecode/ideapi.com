class CommentsController < ApplicationController
  # needs login for all actions
  before_filter :require_user

  make_resourceful do
    belongs_to :brief, :proposal
    
    actions :all
    
    before :create do
      current_object.user = current_user
    end
    response_for( :create_fails, :update_fails) do |format|
      format.html { redirect_to parent_path(:anchor => dom_id(current_object)) }
      format.js{ render :nothing => true}
    end
    response_for(:create, :update) do |format|
      format.html { redirect_to parent_path(:anchor => dom_id(current_object)) }
      format.js{
        current_object = nil
        render :partial => 'briefs/comment', :locals => {:comment => current_object} 
      }
    end 
    
    response_for(:destroy) do |format|
      format.html{ 
        flash[:notice] = 'Comment deleted successfully.'
        redirect_to current_object.commentable 
      }
      format.js{ render :json => current_object.to_json}
    end
  end
  
  def parent_path(path = nil)
    if parent_object.is_a?(Proposal)
      brief_proposal_path(parent_object.brief, parent_object)
    else
      brief_path(parent_object)
    end
  end
  
  private

  def current_brief
    if parent_object.is_a?(Proposal)
      proposal.brief
    else
      parent_object
    end
  end

end
