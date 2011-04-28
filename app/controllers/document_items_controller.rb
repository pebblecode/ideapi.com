class DocumentItemsController < ApplicationController
  
  def create
    @document = Document.find(params[:document_item][:document_id])
    @document_item = DocumentItem.new(params[:document_item])
    @user_question = @document.questions.build
    if @document_item.save 
      respond_to do |format|
        format.html{
          redirect_to @document, :anchor => @document_item
        }
        format.js{
          render :partial => 'documents/document_partials/document_item', :locals => {:current_object => @document, :document_item => @document_item}
        }
      end
        
    else      
      respond_to do |format|
        format.html{
          redirect_to @document
        }
        format.js{
          render :text => "Something went wrong? Please try again.", :status => 500
        }
      end
    end
  end
  
  def update
    @document_item = DocumentItem.find(params[:id])
    
    if @document_item.update_attributes(params[:document_item])
      @document = @document_item.document
      @user_question ||= @document.questions.build(session[:previous_question])
      respond_to do |format|
        format.html{ redirect_to @document_item.document}
        format.js{
          if params[:render].present?
            render :partial => 'documents/document_partials/' << params[:render], :collection => [@document_item], :locals => {:current_object => @document, :document_item => @document_item}
          else
            render :partial => 'documents/document_partials/document_item', :locals => {:current_object => @document, :document_item => @document_item}
          end
        }
      end
    else
      render :nothing => true
    end
  end
  
  def destroy
    @item = DocumentItem.find(params[:id])
    @document = @item.document
    if @item.destroy
      respond_to do |format|
        format.html{
          flash[:notice] = "Section deleted."
          redirect_to @document
        }
        format.js{
          render :nothing => true
        }
      end
    else
      respond_to do |format|
        format.html{
          flash[:error] = "Sorry, there was an error deleting the section. Please try again."
          redirect_to @document
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
        redirect_to documents_path
      }
      format.js{
        render :nothingthing => true
      }
    end
  end
  
  
  def sort
    order = params[:document_item]
    DocumentItem.order(order)
    render :nothing => true
  end
  
  
  def current_object
    @current_object = @document_item.document
  end
  
end