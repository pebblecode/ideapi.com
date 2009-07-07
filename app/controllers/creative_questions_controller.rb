class CreativeQuestionsController < ApplicationController
  
  helper_method :brief_items, :record_author?
  
  def parent_object
    @parent_object ||= parent_model.nil? ? nil : parent_model.find(params["#{parent_name}_id"], :include => :brief_items)
  end
  
  make_resourceful do
    
    before :create do
      current_object.creative = current_user
    end
    
    response_for(:create, :update) do |format|
       format.html { redirect_to objects_path }
    end
    
    belongs_to :brief
    actions :all
  end
  
  def hot
    render :action => :index
  end
  
  def answered
    render :action => :index    
  end
  
  private
  
  def brief_items
    @brief_answers = parent_object.brief_items
  end
  
  def record_author?
    parent_object.author == current_user
  end
  
end
