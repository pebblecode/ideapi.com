class ProposalsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # needs login for all actions
  before_filter :require_user
  before_filter :require_active_brief, :except => [:show]
  
  add_breadcrumb 'dashboard', "/dashboard"
  
  make_resourceful do
    belongs_to :brief
    actions :all
    
    before :new, :create, :edit, :show, :update do
      add_breadcrumb truncate(parent_object.title.downcase, :length => 30), brief_path(parent_object)
    end
    
    before :new, :edit do 
      current_object.assets.build
    end
    
    before :edit, :show, :update do
      add_breadcrumb current_object.title, object_path
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
      format.html { redirect_to edit_object_path }
    end
    
    response_for :update do |format|
      format.html {
        flash[:notice] = "Proposal successfully updated"
        if current_object.draft?
          redirect_to (params[:commit] == "Preview" ? object_path : edit_object_path)
        else
          redirect_to object_path
        end
      }
      
      format.json { render :json => current_object }
    end
    
  end
  
  private
  
  def current_brief
    parent_object
  end

end
