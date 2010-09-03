class TagsController < ApplicationController

  before_filter :require_user

  def index
    @tags = current_account.owned_tags
    respond_to do |format|
      format.json {render :layout => false}
    end
  end

end 
