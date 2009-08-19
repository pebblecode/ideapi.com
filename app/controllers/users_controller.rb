class UsersController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  
  add_breadcrumb 'profile', :object_path, :only => [:show]
  
  before_filter :require_invite, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
    
  def current_object
    @current_object ||= (params[:id].blank?) ? current_user : User.find_by_login(params[:id])
  end
  
  make_resourceful do
    
    after :create do
      @invite.redeem_for_user(current_object)
    end
    
    response_for :create do |format|
      format.html { redirect_to '/' }
    end
    
    actions :new, :create, :show, :edit, :update
  end
 
  private
  
  def require_invite
    if !valid_invite(params[:invite])
      flash[:error] = "You don't have access to that page."
      redirect_to '/'
    end
  end
  
  def valid_invite(code)
    @invite ||= Invitation.pending.find_by_code(code)
  end
 
end
