class SubscriptionAdmin::TemplateQuestionsController < ApplicationController
  before_filter :reject_unauthorized_hosts
  # include ModelControllerMethods
  include AdminControllerMethods
    
  def current_objects
    @current_objects = TemplateQuestion.paginate(:page => params[:page], :per_page => 30, :order => 'body')
  end

  def url_helper_prefix
    "admin_"
  end

  make_resourceful do
    actions :all
  
    response_for :show do |format|
      format.html { redirect_to :action => 'edit' }
    end
    
  end

end
