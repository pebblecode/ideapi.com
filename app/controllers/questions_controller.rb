class QuestionsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  before_filter :require_user
  helper_method :brief_items, :record_author?
    
  def current_objects
    @current_objects ||= (
      if !params[:brief_item_id].blank?
        parent_object.questions.find_all_by_brief_item_id(params[:brief_item_id])
      else
        reset_filter(params[:q])
        parent_object.questions.send(@current_filter)
      end
    )
  end
  
  make_resourceful do
    
    belongs_to :brief
    
    before :index do
      add_breadcrumb 'briefs', briefs_path
      add_breadcrumb truncate(parent_object.title.downcase, :length => 30), brief_path(parent_object)      
      add_breadcrumb 'discussion', objects_path
      
      @brief_item = BriefItem.find(params[:brief_item_id]) if !params[:brief_item_id].blank?
    end
    
    before :create do
      current_object.user = current_user
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
    @brief_answers = parent_object.brief_items.answered
  end
  
  def record_author?
    parent_object.user == current_user
  end
  
  def reset_filter(question_filter)
    @current_objects = nil if @current_filter != question_filter
    @current_filter = question_filter || "recent"
  end
  
end
