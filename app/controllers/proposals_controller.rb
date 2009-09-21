class ProposalsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # needs login for all actions
  before_filter :require_user
  
  add_breadcrumb 'dashboard', "/dashboard"
  
  make_resourceful do
    belongs_to :brief
    actions :all
    
    before :new, :create, :edit, :show, :update do
      add_breadcrumb truncate(parent_object.title.downcase, :length => 30), ''
    end
    
    before :edit, :show, :update do
      add_breadcrumb 'your proposal', object_path
    end
    
    before :create do
      current_object.user = current_user
    end

    before :update do
      params[:proposal][:attachment] = nil if params[:remove_image] == "1" 
    end
    
    after :create, :update do
      if params[:commit] == "Submit proposal"
        current_object.publish!
      end
    end
    
    response_for :show, :show_fails do |format|
      format.html { }
      format.js { render :layout => false }
    end
    
    response_for :update do |format|
      format.html {
        redirect_to (params[:commit] == "Preview" ? object_path : edit_object_path)
      }
    end
    
  end

end
