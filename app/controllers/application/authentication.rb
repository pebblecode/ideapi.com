class ApplicationController < ActionController::Base
    
  # USER_NAME, PASSWORD = "ideapi", "pen34guin"
  # before_filter :authenticate
  
  helper_method :current_user_session, :current_user, :logged_in?, :owner?
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = current_account.user_sessions.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def logged_in?
    !current_user.blank?
  end
    
  def owner?(object)
    object.belongs_to?(current_user)
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
  
  # def authenticate
  #   if RAILS_ENV =~ /staging/
  #     authenticate_or_request_with_http_basic do |user_name, password|
  #       user_name == USER_NAME && password == PASSWORD
  #     end
  #   end
  # end
  
  def attempt_signin(user_params)
    current_account.user_sessions.create(user_params)
  end
  
  def kill_session
    current_user_session.destroy
    flash[:notice] = "You don't have access to that.."
    redirect_back_or_default new_user_session_url
  end

end