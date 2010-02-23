class PagesController < ApplicationController

  layout 'public'
  
  def home
    
  end
  
  def pricing
    
  end
  
  def tour
    
  end
  
  def terms
    
  end
  
  def privacy
    
  end
  
  private
  
  # override application/subscription, to allow www etc to display homepage
  # whilst redirecting any other not found domains to error page
  
  def account_not_found  
    if request.subdomains.blank? || Account.excluded_subdomains.include?(request.subdomains.first)
      render
    else
      redirect_to "/account_not_found" and return
    end
  end
  
end
