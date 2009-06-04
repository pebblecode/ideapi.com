# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  helper_method :brief_config
  
  require_dependency 'application/authentication'  
  
  private
    
    def brief_config
      @brief_config ||= BriefConfig.current
    end
  
end
