class BriefsController < ApplicationController
  before_filter :require_user
  before_filter :current_user_briefs, :only => :index
  
  helper_method :current_user_briefs
  
  def current_objects
    @current_objects ||= current_model.all(:conditions => ["user_id <> ?", current_user.id])
  end
  
  def current_object
    @current_object ||= current_model.find(params[:id], :include => [{:brief_config => :sections}])
  end
  
  make_resourceful do
    before :create do
      current_object.user = current_user
      current_object.brief_config = brief_config
    end
    
    before :update do
      current_object.answers.update(params[:answers].keys, params[:answers].values)
    end
    
    actions :all
  end
  
  private
  
  def current_user_briefs
    @current_user_briefs ||= current_user.briefs
  end
  
end
