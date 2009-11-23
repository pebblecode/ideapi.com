class SubscriptionAdmin::BriefTemplatesController < ApplicationController
  
  include ModelControllerMethods
  include AdminControllerMethods

  def index
    @templates = BriefTemplate.paginate(:page => params[:page], :per_page => 30, :order => 'name')
  end
  

end
