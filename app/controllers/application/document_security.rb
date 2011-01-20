class ApplicationController < ActionController::Base

  # This checks for a valid document state and boots the
  # user back if the states are not found
  # The active method is defined in /app/models/document/states.rb
  def require_active_document
    unless current_document.active?
      flash[:error] = "You cannot do that to a document that isn't active."
      redirect_back_or_default '/'
    end
  end
  
  # override this in your local controller
  def current_document
    raise 'Override current_document in your controller to use require_active_document, see application/document_security.rb'
  end
  
end
