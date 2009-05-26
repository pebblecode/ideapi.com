class BriefsController < ApplicationController
  before_filter :require_user
  
  def current_object
    @current_object ||= current_model.find(params[:id], :include => [:answers, {:brief_config => :sections}])
  end
  
  make_resourceful do
    
    before :create do
      current_object.user = current_user
      current_object.brief_config = brief_config
    end
    
    actions :all
  end
end
