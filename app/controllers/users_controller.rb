class UsersController < ApplicationController
  
  add_breadcrumb 'profile', :object_path, :only => [:show]
  
  #before_filter :require_invite, :only => [:new, :create]
  #before_filter :require_no_user, :only => [:new, :create]

  before_filter :check_user_limit, :only => :create
  before_filter :require_user
  before_filter :require_record_owner, :only => [:edit, :update, :destroy]
    
  def current_object
    @current_object ||= (
      if params[:id].present?
        current_account.users.find_by_login(params[:id])
      else
        if action_name == :show
          current_user
        else
          current_account.users.new(params[:user])
        end
      end
    )
  end
  
  def current_objects
    @current_objects ||= current_account.users
  end
  
  make_resourceful do      
    response_for :create do |format|
      format.html { redirect_to dashboard_path }
    end
    
    actions :all
  end
  
  def invite
    
  end
  
  def signup
    
  end
 
  private
  
  # def require_invite
  #   if !valid_invite(params[:invite])
  #     flash[:error] = "You don't have access to that page."
  #     redirect_to '/'
  #   end
  # end
  # 
  # def valid_invite(code)
  #   @invite ||= Invitation.pending.find_by_code(code)
  # end
  
  def require_record_owner
    not_found unless current_object == current_user
  end
  
  def check_user_limit
    if current_account.reached_user_limit?
      flash[:error] = "The user that invited you needs to upgrade their account to add you, please contact them and try again."
      redirect_to '/'
    end
  end
 
end
