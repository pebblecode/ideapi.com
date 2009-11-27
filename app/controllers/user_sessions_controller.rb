class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy, :delete]
  skip_before_filter :check_for_expired_account

  layout 'login'

  def new
    @user_session = current_account.user_sessions.new
  end

  def create
    if @user_session = attempt_signin(params[:user_session])
      redirect_back_or_default '/'
    else
      render :action => :new
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
