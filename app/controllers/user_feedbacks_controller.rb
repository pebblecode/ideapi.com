class UserFeedbacksController < ApplicationController
  
  def create
    @info = { 
      :browser => request.env['HTTP_USER_AGENT'],
      :page => request.env['HTTP_REFERER'],
      :message => params[:user_feedback][:message],
      :email => params[:user_feedback][:email]
    }
    
    @info[:user] = current_user if current_user
    
    if UserFeedback.deliver_feedback(@info)
      flash[:notice] = "Thanks for the feedback!"
    else
      flash[:error] = "We're really sorry but there was a problem sending feedback, please try again?."
    end
    
    redirect_to request.env['HTTP_REFERER']
  end
  
end
