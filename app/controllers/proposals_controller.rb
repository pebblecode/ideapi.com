class ProposalsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # needs login for all actions
  before_filter :require_user
  before_filter :require_authorized_user
  before_filter :require_active_brief, :except => [:show]
  
  before_filter :require_owner_if_draft, :only => :show
  before_filter :require_owner, :only => :edit
  
  add_breadcrumb 'dashboard', "/dashboard"
  
  make_resourceful do
    belongs_to :brief
    actions :all
    
    before :new, :create, :edit, :show, :update do
      add_breadcrumb truncate(parent_object.title, :length => 30), brief_path(parent_object)
      session[:return_to] = request.request_uri
    end
    
    before :new, :edit do 
      current_object.assets.build
    end
    before :edit do
      add_breadcrumb current_object.title, brief_proposal_path(current_object.brief, current_object)
      add_breadcrumb "edit idea"
    end
    before :new do
      add_breadcrumb "draft new idea"
    end
    before :show, :update do
      add_breadcrumb current_object.title
    end
    
    before :create do
      current_object.user = current_user
    end

    before :update do
      params[:proposal][:attachment] = nil if params[:remove_image] == "1" 
    end
    
    response_for :show, :show_fails do |format|
      format.html { }
      format.js { render :layout => false }
    end
    
    response_for :create do |format|
      format.html { redirect_to object_path }
    end
    
    response_for :update do |format|
      format.html {
        flash[:notice] = "Proposal successfully updated"
        redirect_to object_path
      }
      
      format.json { 
        render :json => current_object 
      }
    end
    
  end
  
  private
  
  def current_brief
    parent_object
  end



  def require_owner_if_draft
    if current_object.draft? and not current_object.user == current_user
      flash[:notice] = "You must be the owner of the idea while it's still a draft."
      redirect_to brief_path(current_object.brief)
    end
  end
  def authorized_users
    # brief authors, brief approver, and proposal user (owner)
    [current_object.user, current_object.brief.authors, current_object.brief.approver].uniq.flatten
  end
  def require_authorized_user
    unless authorized_users.include? current_user
      redirect_to brief_path(current_object.brief)
    end
  end
  
  def require_owner
    unless current_object.user == current_user
      flash[:notice] = "Access error: you can only edit proposals you own."
      redirect_to brief_path(current_object.brief)
    end
  end
end
