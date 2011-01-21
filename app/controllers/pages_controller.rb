class PagesController < ApplicationController
  before_filter :user_session_setup
  before_filter :require_user, :only => :help
  
  before_filter :no_cache
  
  layout 'landing'

  def home
    if account_present? && current_account
      redirect_to documents_url
    end    
  end

  def faq
    
  end
  
  def pricing
    
  end
  
  def tour
    
  end
  
  def terms
    
  end
  def who
    
  end
  def privacy
    
  end
  
  def help
      add_breadcrumb 'help', '/help'
    render :layout => 'application'
  end

  def login
    @user_session = UserSession.new(params[:user_session])
    session["password"] = params[:user_session][:password] if params[:user_session]
    if @user_session.save
      flash[:notice] = "You are now logged in."
      @user = User.find(:first, :conditions => {:id => session["user_credentials_id"]})
      if @user.present? and @user.accounts.present?
        if @user.accounts.count == 1
          redirect_to domain_with_port(@user.accounts.first.full_domain) 
        else
          render :layout => "login"
        end
      end
    else
      render :layout => "login"
    end
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

  def user_session_setup
    @usersession = UserSession.new
    session[:return_to] = request.url
    if session["user_credentials_id"].present?
      @user = User.find(session["user_credentials_id"])
    end
  end
  
  
  def domain_with_port(domain, with_port = false)
    port = self.request.port
    if with_port
      "http://#{domain}:#{port}/"
    else
      "http://#{domain}/"
    end
  end
  
  def no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
