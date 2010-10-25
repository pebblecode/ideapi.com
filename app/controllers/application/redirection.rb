class ApplicationController < ActionController::Base

  before_filter :check_for_return
  
  private
  
  def check_for_return    
    store_location(params[:return_to]) if params[:return_to].present?
  end

  def store_location(location = request.request_uri)
    session[:return_to] = location
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default) and return
    session[:return_to] = nil
  end
  
  def not_found
    redirect_to '/404' and return
  end
  
end