class BriefsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # needs login for all actions
  before_filter :require_user
  
  before_filter :require_account_brief_permissions, :only => [:new, :create]
  
  # filters for record owners
  before_filter :require_owner, :only => [:edit, :update, :destroy, :collaborators]

  after_filter :record_user_view, :only => [:show]

  # ensure brief is active
  before_filter :require_active_brief, :only => [:edit, :update, :collaborators]

  helper_method :completed_briefs
  
  add_breadcrumb 'dashboard', "/dashboard"
  
  add_breadcrumb 'create a new brief', :new_object_path, :only => [:new, :create]
  
  def current_objects
    @current_objects ||= current_user.briefs.active.by_account(current_account, {:order => "updated_at DESC"})
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
        
    before :index do
      completed_briefs(:limit => 5, :order => "updated_at DESC")
    end
    
    before :show do
      add_breadcrumb truncate(current_object.title.downcase, :length => 30), object_path
      @brief_proposals = current_object.proposal_list_for_user(current_user).group_by(&:state)
      @user_question ||= current_object.questions.build(session[:previous_question])
    end
    
    before :create do
      current_object.account = current_account
      current_object.author = current_user
      current_object.template_brief = TemplateBrief.last      
    end
              
    before (:edit, :update) do
      add_breadcrumb truncate(current_object.title.downcase, :length => 30), object_path
      add_breadcrumb 'edit brief', :edit_object_path
    end
        
    after :update do
      if params[:brief].keys.include?("_call_state")
        flash[:notice] = "Brief has been saved and marked as #{current_object.state}."
      end     
    end
    
    response_for(:create) do |format|
      format.html { redirect_to edit_object_path }
    end
    
    response_for(:index) do |format|
      format.html
    end
    
    response_for(:update, :update_fails) do |format|
      format.html { redirect_back_or_default :action => current_object.draft? ? 'edit' : 'show' }
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
    
    @users_available_to_add = current_account.users - current_object.users
    
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end
  
  def completed
    completed_briefs({:order => "updated_at DESC"})
  end
  
  private
  
  def completed_briefs(options = {})
    @completed_briefs ||= current_user.briefs.complete.by_account(current_account, options)
  end
     
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
  
  def require_account_brief_permissions
    not_found unless current_user_can_create_briefs?
  end
  
  def current_brief
    current_object
  end
  
end
