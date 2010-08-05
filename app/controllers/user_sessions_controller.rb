class UserSessionsController < ApplicationController
  # make sure user is logged out for certain views
  before_filter :require_no_user, :only => [:new, :create]
  
  # make sure user is logged in for certain views
  before_filter :require_user, :only => [:destroy, :delete]

  def new
    @user_session = current_account.user_sessions.new
  end

  layout "login"
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "You are now logged in."
      if session[:return_to]
        redirect_to session[:return_to]
      else
        # Redirect to dashboard if there's no return_to path.
        redirect_to dashboard_url
      end
    else
      render :action => 'new'
    end
  end

  def delete
    
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
