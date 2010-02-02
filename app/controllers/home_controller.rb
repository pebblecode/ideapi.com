class HomeController < ApplicationController

  layout 'public'
  
  def show
    if account_present? && current_account
      redirect_to dashboard_url
    else
      redirect_to "/home.html"      
    end
  end
  
  private
  
  # override application/subscription, to allow www etc to display homepage
  # whilst redirecting any other not found domains to error page
  
  def account_not_found  
    if request.subdomains.blank? || Account.excluded_subdomains.include?(request.subdomains.first)
      redirect_to "/home.html"
      # render
    else
      redirect_to "/account_not_found" and return
    end
  end
  
end
