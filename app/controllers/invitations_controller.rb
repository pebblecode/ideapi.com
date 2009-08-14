class InvitationsController < ApplicationController

  def create
    @invitations = Invitation.from_list_into_hash(params[:invitation][:recipient_list], current_user)
    
    send_invitations_for(@invitations[:successful]) if !@invitations[:successful].blank?
    
    set_flash_notices_for(@invitations)
    
    redirect_back_or_default user_path(current_user)
  end
  
  def show
    @invitation = Invitation.find_by_code(params[:id])
    if @invitation && @invitation.pending?
      redirect_to new_user_path(:invite => @invitation.code)
    else
      flash[:error] = @invitation ? "Invitation is no longer valid" : "Invitation is not valid"
      redirect_back_or_default '/'
    end
  end
  
  def resend
    

    if @invitation = find_pending(params[:id])
      send_invitations_for([@invitation])
      flash[:notice] = "Invitation has been resent to #{@invitation.recipient_email}"
    else
      flash[:notice] = "Invitation could not be found or has been accepted"
    end
    redirect_back_or_default user_path(current_user)
  end
  
  def cancel
    if find_pending(params[:id]).cancel!
      flash[:notice] = "Invitation has been cancelled"
    else
      flash[:notice] = "Invitation could not be found or has been accepted"
    end
    redirect_back_or_default user_path(current_user) 
  end
  
  private
  
  def find_pending(code)
    current_user.invitations.pending.find_by_code(code)
  end
  
  def send_invitations_for(invites)
    invites.each {|invite| InvitationMailer.deliver_invitation(invite) }
  end

  def set_flash_notices_for(invitations)
    if !invitations[:successful].blank? # ignore failed ones for now ..
      flash[:notice] = "An invite has been sent to #{invitations[:successful].map(&:recipient_email).join(',')}"
    elsif !invitations[:failed].blank?
      flash[:error] = "Couldn't send invitation to #{invitations[:failed].map(&:recipient_email).join(',')}"
    else
      flash[:error] = "There was a problem sending invitiations, please check and try again."
    end
  end

end
