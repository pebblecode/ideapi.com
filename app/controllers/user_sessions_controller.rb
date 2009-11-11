class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy, :delete]

  layout 'login'

  def new
    @user_session = current_account.user_sessions.new
  end

  def create
    if @user_session = current_account.user_sessions.create(params[:user_session])
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
