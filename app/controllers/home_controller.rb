class HomeController < ApplicationController
  
  add_breadcrumb 'home', '/'
  
  def show
    redirect_to briefs_path and return if logged_in?
  end
end
