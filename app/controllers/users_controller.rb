class UsersController < ApplicationController
  
  add_breadcrumb 'profile', :object_path, :only => [:show]
  
  before_filter :require_no_user, :only => :signup
  before_filter :require_user, :except => [:signup, :update]
  before_filter :require_user_unless_pending, :only => :update
  
  before_filter :check_user_limit, :only => :create
  before_filter :require_record_owner, :only => [:edit, :update, :destroy]
  
  before_filter :account_admin_required, :except => [:signup, :update, :index]
  
  def current_object
    @current_object ||= (params[:id].blank?) ? current_user : User.find_by_login(params[:id])
  end
  
  def current_objects
    @current_objects ||= current_account.account_users(:include => :user)
  end
  
  make_resourceful do      
    response_for :create do |format|
      format.html { redirect_to users_path }
    end
    
    actions :all
    
    after :create do
      unless current_account.users.include?(current_object)
        current_account.users << current_object
      end
    end
        
  end
  
  def signup
    if @current_object = current_account.users.pending.find_by_invite_code(params[:invite_code])
      if request.put?
        current_object.attributes = params[:user]
        if current_object.activate!      
          if @user_session = attempt_signin(current_object)
            redirect_back_or_default '/'
          end
        end
      end
    else
      not_found
    end
  end
 
  private
  
  def build_object
    @current_object = current_model.find_or_initialize_by_email(object_parameters)  
  end
  
  def require_record_owner
    not_found unless current_object == current_user
  end
  
  def check_user_limit
    if current_account.reached_user_limit?
      flash[:error] = "The user that invited you needs to upgrade their account to add you, please contact them and try again."
      redirect_to '/'
    end
  end
  
  def require_user_unless_pending
    require_user unless current_object.pending?
  end
 
end
