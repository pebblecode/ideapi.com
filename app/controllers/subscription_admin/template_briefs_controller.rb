class SubscriptionAdmin::TemplateBriefsController < ApplicationController
  
  # include ModelControllerMethods
  include AdminControllerMethods
  
  # def index
  #   @templates = TemplateBrief.paginate(:page => params[:page], :per_page => 30, :order => 'title')
  # end

  make_resourceful do
    actions :all
  end

end
