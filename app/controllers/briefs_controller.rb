class BriefsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # needs login for all actions
  before_filter :require_user
  
  # filters for record owners
  before_filter :require_owner, :only => [:edit, :update, :destroy, :collaborators]
  
  after_filter :record_user_view, :only => [:show]
  
  add_breadcrumb 'dashboard', "/dashboard"
  add_breadcrumb 'create a new brief', :new_object_path, :only => [:new, :create]
  add_breadcrumb 'edit your brief', :edit_object_path, :only => [:edit, :update]
  
  def current_objects
    @current_objects ||= current_user.briefs
  end
  
  def current_object
    @current_object ||= current_user.briefs.find(params[:id], 
      :include => [
        :comments, :questions,
        { 
          :brief_items_answered => [
            :timeline_events
          ] 
        }
      ]
    )
  end
  
  make_resourceful do
    belongs_to :user
    actions :all
    
    before :show do
      add_breadcrumb truncate(current_object.title.downcase, :length => 30), object_path      
      @brief_proposals = current_object.proposal_list_for_user(current_user).group_by(&:state)
      @user_question ||= current_object.questions.build(session[:previous_question])
    end
    
    before :create do
      current_object.author = current_user
      current_object.template_brief = TemplateBrief.last      
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
      format.html { redirect_back_or_default :action => current_object.published? ? 'show' : 'edit' }
      format.json { render :json => current_object.reload.to_json(:include => :user_briefs, :methods => :json_errors) }
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
  
  def watch
    if !record_owner?      
      current_user.toggle_watch!(current_object)
    end
    
    respond_to do |format|
      format.html { redirect_to object_path }
    end
  end
  
  def collaborators
    current_object.user_briefs.build
    
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end
  
  private
     
  def require_owner
    redirect_to briefs_path and return unless record_owner?
  end
  
  def require_owner_if_not_published
    redirect_to briefs_path and return if (!record_owner? && !current_object.published?)
  end

  def record_owner?
    current_object.belongs_to?(current_user)
  end
  
  def record_user_view
    current_object.user_briefs.for_user(current_user).touch(:last_viewed_at)
  end
  
end
