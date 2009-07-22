class CreativeQuestionsController < ApplicationController
  before_filter :require_user
  helper_method :brief_items, :record_author?

  def current_objects
    reset_filter(params[:q])
    @current_objects ||= parent_object.creative_questions.send(@current_filter)
  end
  
  make_resourceful do
    
    belongs_to :brief
    
    before :create do
      current_object.creative = current_user
    end
    
    after :create do
      current_user.watch(parent_object)
    end
    
    response_for(:index) do |format|
      format.html
      format.js { render :action => 'ask_question', :layout => false }
    end
    
    response_for(:create, :update) do |format|
       format.html { redirect_to objects_path }
    end
    
    belongs_to :brief
    actions :all
  end
  
  private
  
  def brief_items
    @brief_answers = parent_object.brief_items
  end
  
  def record_author?
    parent_object.author == current_user
  end
  
  def reset_filter(question_filter)
    @current_objects = nil if @current_filter != question_filter
    @current_filter = question_filter || "recent"
  end
  
end
