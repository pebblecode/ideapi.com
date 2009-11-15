class UsersController < ApplicationController
  
  add_breadcrumb 'profile', :object_path, :only => [:show]
  
  before_filter :require_no_user, :only => :signup
  before_filter :require_user, :except => :signup
  
  before_filter :check_user_limit, :only => :create
  before_filter :require_record_owner, :only => [:edit, :update, :destroy]
      # 
      # def current_object
      #   @current_object ||= (
      #     if params[:id].present?
      #       current_account.users.find_by_login(params[:id])
      #     else
      #       current_user
      #     end
      #   )
      # end
  
  def current_objects
    @current_objects ||= current_account.users
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
 
end
