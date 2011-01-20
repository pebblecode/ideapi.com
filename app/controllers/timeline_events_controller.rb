class TimelineEventsController < ApplicationController
  make_resourceful do
    actions :destroy
        
    response_for :destroy do |format|
      format.html{ 
        if current_object.subject.respond_to? 'document_item' #it's a document_item version
          redirect_to current_object.subject.document_item.document
        elsif current_object.subject.respond_to? 'document_items' # it's a document
          redirect_to current_object.subject
        else
          redirect_to documents_url
        end
          
      }
      format.js{ render :nothing => true } # Render nothing when deleting via ajax
      
    end
    
  end
end