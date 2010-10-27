class CommentsController < ApplicationController
  # needs login for all actions
  before_filter :require_user
  before_filter :store_object, :only => :destroy

  make_resourceful do
    belongs_to :brief, :proposal
    
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
        render :partial => 'briefs/comment', :locals => {:comment => current_object} 
      }
    end 
    
    after(:destroy) do
      logger.info('PARENT OBJECT : ', parent_object)
      logger.info('CURRENT OBJECT : ',  current_object)
    end
    
    response_for(:destroy) do |format|
      format.html{

        flash[:notice] = 'Comment deleted successfully.'
        if @commentable.is_a?(Proposal)
          redirect_to brief_proposal_path(@commentable.brief, @commentable)
        elsif @commentable.is_a?(Brief)
          redirect_to brief_path(@commentable)
        else
          redirect_to dashboard_url
        end
      }
      format.js{ render :json => current_object.to_json}
    end
  end
  def store_object
    @commentable = current_object.commentable
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
