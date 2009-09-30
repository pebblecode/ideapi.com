class BriefsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # needs login for all actions
  before_filter :require_user
  
  # filters for record owners
  before_filter :require_owner_if_not_published, :only => [:show]
  before_filter :require_owner, :only => [:edit, :update, :destroy]
  
  # get the brief items (depending on brief state)
  helper_method :current_brief_items, :user_last_viewed_brief
  
  add_breadcrumb 'dashboard', "/dashboard"
  add_breadcrumb 'create a new brief', :new_object_path, :only => [:new, :create]
  add_breadcrumb 'edit your brief', :edit_object_path, :only => [:edit, :update]
  
  make_resourceful do
    belongs_to :user
    actions :all
    
    before :show do
      add_breadcrumb truncate(current_object.title.downcase, :length => 30), object_path
      set_user_last_viewed_brief
      
      current_object.watched_briefs.build
      
      # record view
      current_object.brief_user_views.record_view_for_user(current_user)
      
      #@invitation = Invitation.new(:user => current_user, :redeemable => current_object)
    end
    
    
    before :create do
      current_object.template_brief = TemplateBrief.last
      current_object.user = parent_object
    end
        
    after :update do
      if (params[:commit] == "publish")
        current_object.publish!
        if current_object.published?
          @published = true
          flash[:notice] = "Brief has been saved and published."
        else
          flash[:error] = "Brief could not be published, any changes have been saved."
        end
      end
    end
    
    response_for(:create) do |format|
      format.html { redirect_to edit_object_path }
    end
    
    response_for(:index) do |format|
      format.html
    end
    
    response_for(:update, :update_fails) do |format|
      format.html { redirect_to :action => current_object.published? ? 'show' : 'edit' }
      format.json { render :json => current_object }  
    end
  
    response_for(:show, :show_fails) do |format|
    
      format.html { 
                
        if current_object.draft? 
          redirect_to(:action => 'edit') 
        else
          if params[:print_mode].present?
            @print_mode = params[:print_mode]
            render(:action => 'print', :layout => false) 
          else
            render 
          end
        end
        
      }
      
      format.js { render :layout => false }
      
      format.json { render :json => current_object }
    end
    
  end
  
  # def browse
  #   @search_results = Brief.search(params[:q])
  #   respond_to do |format|
  #     format.html
  #   end
  # end
  
  def watch
    if !record_owner?      
      current_user.toggle_watch!(current_object)
    end
    
    respond_to do |format|
      format.html { redirect_to object_path }
    end
  end
  
  private
  
  # parent_object is standard make_resourceful accessor
  # overwrite with our current logged in user
  alias :parent_object :current_user
     
  def require_owner
    redirect_to briefs_path and return if !record_owner?
  end
  
  def require_owner_if_not_published
    redirect_to briefs_path and return if (!record_owner? && !current_object.published?)
  end

  def record_owner?
    current_object.belongs_to?(current_user)
  end
  
  def user_last_viewed_brief
    @user_last_viewed_brief ||= set_user_last_viewed_brief
  end
  
  def set_user_last_viewed_brief
    @user_last_viewed_brief = current_object.brief_user_views.for_user(current_user)
  end
  
end
