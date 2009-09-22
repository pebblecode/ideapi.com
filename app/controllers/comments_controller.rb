class CommentsController < ApplicationController
  # needs login for all actions
  before_filter :require_user

  make_resourceful do
    belongs_to :brief, :proposal
    
    actions :all
    
    before :create do
      current_object.user = current_user
    end
    
    response_for :create, :update do |format|
      format.html { redirect_to parent_path }
    end
    
  end
  
  def parent_path
    if parent_object.is_a?(Proposal)
      brief_proposal_path(parent_object.brief, parent_object)
    else
      super
    end
  end

end
