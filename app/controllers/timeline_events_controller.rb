class TimelineEventsController < ApplicationController
  make_resourceful do
    actions :destroy
        
    response_for :destroy do |format|
      format.html{ 
        if current_object.subject.respond_to? 'brief_item' #it's a brief_item version
          redirect_to current_object.subject.brief_item.brief
        elsif current_object.subject.respond_to? 'brief_items' # it's a brief
          redirect_to current_object.subject
        else
          redirect_to documents_url
        end
          
      }
      format.js{ render :nothing => true } # Render nothing when deleting via ajax
      
    end
    
  end
end