class ApplicationController < ActionController::Base

  def require_active_brief
    unless current_brief.active?
      flash[:error] = "You cannot do that to a brief that isn't active."
      redirect_back_or_default '/'
    end
  end
  
  # override this in your local controller
  def current_brief
    raise 'Override current_brief in your controller to use require_active_brief, see application/brief_security.rb'
  end
  
end