class BriefsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :current_user_briefs, :only => :index
  helper_method :current_user_briefs
  
  def current_objects
    @current_objects ||= (
      options = logged_in? ? {:conditions => ["user_id <> ?", current_user.id]} : {}
      current_model.all(options)
    )
  end
  
  def current_object
    @current_object ||= ((action_name == "show") ? current_model : current_user_briefs).find(params[:id], :include => [{:brief_template => :brief_sections}, :comments])
  end
  
  make_resourceful do
    before :create do
      current_object.user = current_user
    end
    
    before(:new, :edit) do
      @brief_templates = BriefTemplate.all
    end
    
    before :show do
      @comment = current_object.comments.new
    end
    
    before :update do
      if !params[:answers].blank?
        current_object.brief_answers.update(params[:answers].keys, params[:answers].values)
      end
    end
    
    actions :all
  end
  
  private
  
  def current_user_briefs
    logged_in? ? current_user.briefs : []
  end
  
end
