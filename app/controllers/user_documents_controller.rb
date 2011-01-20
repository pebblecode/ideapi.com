class UserDocumentsController < ApplicationController
  def create
    @user_document = UserDocument.create(params[:user_document])
    if @user_document.save
      respond_to do |format|
        format.html{
          flash[:notice] = "#{@user_document.user.full_name} has been added to the document."
          redirect_to @user_document.document
        }
        format.js{
          render :partial => 'documents/update_collaborators_form', :locals => {:current_object => @user_document.document}
        }
      end
    else
      respond_to do |format|
        format.html{
          
        }
        format.js{
          render :text => 'ERROR'
        }
      end
    end
  end
  
  def update
    begin
      @user_document = UserDocument.find(params[:id])
      @document = @user_document.document
      if @user_document.update_attributes(params[:user_document])
        respond_to do |format|
          format.html{
            flash[:notice] = 'User role updated.'
            redirect_to @document and return
          }
          format.js{
            render :partial => 'documents/update_collaborators_form', :locals => {:current_object => @document}
          }
        end
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html{
          flash[:error] = 'The user is no longer in this document.'
          redirect_to documents_url and return
        }
        format.js{
          render :text => 'Record not found.' and return
        }
      end
    rescue RuntimeError => e
      respond_to do |format|
        format.html{
          flash[:error] = e
          if @document.present? 
            redirect_to @document
          else
            redirect_to documents_path
          end
        }
        format.js{
          render :text => e, :status => 500
        }
      end
    end
  end
  
  def destroy
    begin
      @user_document = UserDocument.find(params[:id])
      @document = @user_document.document
      if @user_document.destroy
        respond_to do |format|
          format.html{
            flash[:notice] = 'User removed from document.'
            redirect_to @document and return
          }
          format.js{
            render :partial => 'documents/update_collaborators_form', :locals => {:current_object => @document}
          }
        end
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html{
          flash[:error] = 'The user is no longer in this document.'
          redirect_to documents_url and return
        }
        format.js{
          render :text => 'Record not found.' and return
        }
      end
    rescue RuntimeError => e
      respond_to do |format|
        format.html{
          flash[:error] = e.message
          if @document.present? 
            redirect_to @document
          else
            redirect_to documents_path
          end
        }
        format.js{
          render :text => e.message, :status => 500
        }
      end
    end
  end
  
end