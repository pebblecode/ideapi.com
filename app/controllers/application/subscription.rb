# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #include AuthenticatedSystem
  include SslRequirement
  include SubscriptionSystem
  
  before_filter :account_required
    
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '779a6e2f0fe7736f0a73da4a7d9f13d4'
  
  private
  
  def account_required
    begin
      current_account
    rescue ActiveRecord::RecordNotFound => e
      account_not_found
    end
  end
  
  def account_not_found
    redirect_to "/account_not_found" and return
  end
  
end
