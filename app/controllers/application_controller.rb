# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation  
  
  require_dependency 'application/redirection'  
  require_dependency 'application/authentication'  
  require_dependency 'application/subscription'  
  
  helper_method :brief_config
  
  private
    
    def brief_config
      @brief_config ||= BriefConfig.current
    end
  
end
