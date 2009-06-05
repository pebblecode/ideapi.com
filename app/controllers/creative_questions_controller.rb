class CreativeQuestionsController < ApplicationController
  
  def current_objects
    @current_objects ||= CreativeQuestion.all(:conditions => ["brief_answer_id IN (?)", brief.brief_answer_ids])
  end
  
  make_resourceful do
    actions :all
  end
  
  private
  
  def brief
    @brief = Brief.find(params[:brief_id])
  end
end
