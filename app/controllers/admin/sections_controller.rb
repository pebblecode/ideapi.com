class Admin::SectionsController < Admin::BaseController
  before_filter :question_list, :only => [:edit]
  
  make_resourceful do
    actions :all
  
    response_for(:show) do |format|
      format.html { redirect_to :action => :edit }
    end
  end
  
  private
  
  def question_list
    @questions = Question.all
  end
end
