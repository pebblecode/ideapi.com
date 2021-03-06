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
      user = @user_session.user
      user.user_agent_string = request.headers['HTTP_USER_AGENT']
      user.save
      if session[:return_to]
        redirect_to session[:return_to]
      else
        # Redirect to documents if there's no return_to path.
        redirect_to documents_url
      end
    else
      @error_messages = get_error_messages(@user_session)
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
