class BriefItemsController < ApplicationController
  
  def create
    
  end
  
  def update
    @brief_item = BriefItem.find(params[:id])
    
    if @brief_item.update_attributes(params[:brief_item])
      @brief = @brief_item.brief
      @user_question ||= @brief.questions.build(session[:previous_question])
      respond_to do |format|
        format.html{ redirect_to @brief_item.brief}
        format.js{
          if params[:render].present?
            render :partial => 'briefs/brief_partials/' << params[:render], :collection => [@brief_item], :locals => {:current_object => @brief, :brief_item => @brief_item}
          else
            render :partial => 'briefs/brief_partials/brief_item', :locals => {:current_object => @brief_item.brief, :brief_item => @brief_item}
          end
        }
      end
    else
      render :nothing => true
    end
  end
  
  def current_object
    @current_object = @brief_item.brief
  end
end