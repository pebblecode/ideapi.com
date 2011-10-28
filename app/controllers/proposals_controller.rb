class ProposalsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # needs login for all actions
  before_filter :require_user
  before_filter :require_authorized_user, :except => [:index]
  before_filter :require_active_document, :except => [:show, :index]
  
  before_filter :require_document_author_or_proposal_author_if_draft, :only => :show
  before_filter :require_owner, :only => :edit
  
  add_breadcrumb 'documents', "/documents"
  
  make_resourceful do
    belongs_to :document
    actions :all
    
    before :index do
      # Capture filters (all, archived, active)
      case params[:show]
        when 'active': @briefs = current_user.documents.active
        when 'archived': @briefs = current_user.documents.archived
        else @briefs = current_user.documents
      end
    end
    before :new, :create, :edit, :show, :update do
      add_breadcrumb truncate(parent_object.title, :length => 30), document_path(parent_object)
      session[:return_to] = request.request_uri
    end
    
    before :new, :edit do 
      current_object.assets.build
    end
    before :edit do
      add_breadcrumb current_object.title, document_proposal_path(current_object.document, current_object)
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
      format.html { 
        flash[:notice] = "Idea successfully created"
        redirect_to object_path 
      }
    end
    
    response_for :update do |format|
      format.html {
        flash[:notice] = "Idea successfully updated"
        redirect_to object_path
      }
      
      format.json { 
        render :json => current_object 
      }
    end
    
    response_for :destroy do |format|
      format.html {
        flash[:notice] = 'Idea successfully deleted'
        redirect_to parent_object
      }
    end
    
  end
  
  private
  
  def current_document
    parent_object
  end



  def require_document_author_or_proposal_author_if_draft
    if (current_object.draft? and
        not([current_object.user, current_document.author].include? current_user))
      flash[:notice] = "You must be the owner of the idea while it's still a draft."
      redirect_to document_path(current_object.document)
    end
  end
  def authorized_users
    # document authors, document approver, and proposal user (owner)
    if current_object.present? 
      return [current_object.user, current_object.document.authors, current_object.document.approver].uniq.flatten
    else
      return [parent_object.users].uniq.flatten
    end
  end
  def require_authorized_user
    unless authorized_users.include? current_user
      redirect_to document_path(parent_object)
    end
  end
  
  def require_owner
    unless current_object.user == current_user
      flash[:notice] = "Access error: you can only edit proposals you own."
      redirect_to document_path(current_object.document)
    end
  end
end
