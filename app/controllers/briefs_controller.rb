class BriefsController < ApplicationController
  # needs login for all actions
  before_filter :require_user
  
  # filters for record owners
  before_filter :require_owner_if_not_published, :only => [:show]
  before_filter :require_owner, :only => [:edit, :update, :destroy]
  
  # get the brief items (depending on brief state)
  helper_method :current_brief_items, :user_last_viewed_brief
  
  add_breadcrumb 'dashboard', :briefs_path, :only => [:index]
  add_breadcrumb 'briefs', :briefs_path, :except => [:index]
  
  add_breadcrumb 'create a new brief', :new_object_path, :only => [:new, :create]
  add_breadcrumb 'edit your brief', :edit_object_path, :only => [:edit, :update]
  
  def current_objects
    @current_objects ||= parent_object.briefs_grouped_by_state
  end
    
  make_resourceful do
    belongs_to :user
    actions :all
    
    before :show do
      add_breadcrumb current_object.title.downcase, object_path
      set_user_last_viewed_brief
      
      # record view
      current_object.brief_user_views.record_view_for_user(current_user)      
    end
    
    before :create do
      current_object.template_brief = TemplateBrief.last
      current_object.user = parent_object
    end
    
    after :create do
      flash[:notice] = "Brief has been created successfully."
    end
    
    after :update do
      if (params[:commit] == "publish")
        current_object.publish!
        if current_object.published?
          flash[:notice] = "Brief has been saved and published."
        else
          flash[:error] = "Brief could not be published, any changes have been saved."
        end
      else
        flash[:notice] = "Brief has been updated."
      end
    end
    
    response_for(:create) do |format|
      format.html { redirect_to edit_object_path }
    end
    
    response_for(:index) do |format|
      # display a different view depending on the user type
      format.html
    end
    
    response_for(:update, :update_fails) do |format|
      format.html { redirect_to :action => 'edit' }
      format.json { render :json => current_object }  
    end
  
    response_for(:show, :show_fails) do |format|
      format.html { current_object.draft? ? redirect_to(:action => 'edit') : render }
      format.json { render :json => current_object }  
    end
    
  end
  
  def browse
    @search_results = Brief.search(params[:q])
    respond_to do |format|
      format.html
    end
  end
  
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
