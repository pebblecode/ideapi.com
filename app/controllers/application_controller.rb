# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation  
  
  require_dependency 'application/redirection'  
  require_dependency 'application/authentication'  
  require_dependency 'application/subscription'  
  require_dependency 'application/brief_security'
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  before_filter :set_current_user
  
  def set_current_user
    if logged_in?
      User.current = current_user
    end
  end
end
