# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SslRequirement
  include SubscriptionSystem
  
  before_filter :account_required
  
  helper_method :current_user_can_create_documents?
  
  before_filter :check_for_expired_account
  
  private

  def account_present?
    request.subdomains.present? && !(request.subdomains.present? && Account.excluded_subdomains.include?(request.subdomains.first))
  end
  
  def account_required    
    if account_present?
      begin
        current_account
      rescue ActiveRecord::RecordNotFound => e
        account_not_found
      end
    end
  end
  
  def account_admin_required
    not_found unless admin?
  end
  
  def account_not_found
    redirect_to "/account_not_found" and return
  end
  
  def current_user_can_create_documents?
    current_account.document_authors.include?(current_user)
  end
  
  def check_for_expired_account
    # if account_present?
    #   unless current_account.subscription.current?  
    #     if current_account.admin?(current_user)
    #       redirect_to account_path
    #     else
    #       redirect_to '/account_expired' and return
    #     end
    #   end
    # end
  end
  
  
  def reject_unauthorized_hosts
    admin_authorized_hosts = ['188.220.62.130', '78.86.163.223', '127.0.0.1']
    logger.info(request.remote_ip)
    not_found unless admin_authorized_hosts.include?(request.remote_ip)
  end
end
