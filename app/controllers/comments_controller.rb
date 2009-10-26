class CommentsController < ApplicationController
  # needs login for all actions
  before_filter :require_user

  make_resourceful do
    belongs_to :brief, :proposal
    
    actions :all
    
    before :create do
      current_object.user = current_user
    end

    response_for(:create, :update, :create_fails, :update_fails) do |format|
      format.html { redirect_to parent_path(:anchor => dom_id(current_object)) }
    end
    
  end
  
  def parent_path
    if parent_object.is_a?(Proposal)
      brief_proposal_path(parent_object.brief, parent_object)
    else
      brief_path(parent_object)
    end
  end

end
