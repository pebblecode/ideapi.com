class HomeController < ApplicationController
  def show
    redirect_to briefs_path and return if logged_in?
  end
end
