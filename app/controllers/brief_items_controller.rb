class BriefItemsController < ApplicationController
  
  def create
    @brief = Brief.find(params[:brief_item][:brief_id])
    @brief_item = BriefItem.new(params[:brief_item])
    @user_question = @brief.questions.build
    if @brief_item.save 
      respond_to do |format|
        format.html{
          redirect_to @brief, :anchor => @brief_item
        }
        format.js{
          render :partial => 'briefs/brief_partials/brief_item', :locals => {:current_object => @brief, :brief_item => @brief_item}
        }
      end
        
    else
      respond_to do |format|
        format.html{
          redirect_to @brief
        }
        format.js{
          render :nothing => true
        }
      end
    end
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
            render :partial => 'briefs/brief_partials/brief_item', :locals => {:current_object => @brief, :brief_item => @brief_item}
          end
        }
      end
    else
      render :nothing => true
    end
  end
  
  def destroy
    @item = BriefItem.find(params[:id])
    @brief = @item.brief
    if @item.destroy
      respond_to do |format|
        format.html{
          flash[:notice] = "Section deleted."
          redirect_to @brief
        }
        format.js{
          render :nothing => true
        }
      end
    else
      respond_to do |format|
        format.html{
          flash[:error] = "Sorry, there was an error deleting the section. Please try again."
          redirect_to @brief
        }
        format.js{
          render :nothing => true
        }
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html{
        flash[:error] = 'Illegal request'
        redirect_to dashboard_path
      }
      format.js{
        render :nothingthing => true
      }
    end
  end
  
  
  def sort
    order = params[:brief_item]
    BriefItem.order(order)
    render :nothing => true
  end
  
  
  def current_object
    @current_object = @brief_item.brief
  end
  
end