class TimelineEventsController < ApplicationController
  make_resourceful do
    actions :destroy
        
    response_for :destroy do |format|
      format.js{ render :nothing => true } # Render nothing when deleting via ajax
      
    end
    
  end
end