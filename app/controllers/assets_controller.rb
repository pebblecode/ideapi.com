class AssetsController < ApplicationController
  
  before_filter :require_user
  
  def destroy
    if params[:id]
      Asset.find(params[:id]).delete
    end
    redirect_to :back
    
  end
end