class ApplicationController < ActionController::Base
    
  USER_NAME, PASSWORD = "ideapi", "pen34guin"
  before_filter :authenticate
  
  helper_method :current_user_session, :current_user, :logged_in?, :owner?
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
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
      redirect_to home_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def authenticate
    if RAILS_ENV =~ /production|staging/
      authenticate_or_request_with_http_basic do |user_name, password|
        user_name == USER_NAME && password == PASSWORD
      end
    end
  end
  
  def kill_session
    current_user_session.destroy
    flash[:notice] = "You don't have access to that.."
    redirect_back_or_default new_user_session_url
  end

end