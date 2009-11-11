class HomeController < ApplicationController

  layout 'public'
  
  def show
    if current_account
      redirect_to dashboard_url
    end
  end
  
  private
  
  # override application/subscription, to allow www etc to display homepage
  # whilst redirecting any other not found domains to error page
  
  def account_not_found
    unless Account.excluded_subdomains.include?(request.subdomains.first)
      redirect_to "/account_not_found" and return
    end
  end
  
end
