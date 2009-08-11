class InvitationsController < ApplicationController

  def create
    @invitations = Invitation.from_list_into_hash(params[:invitation][:recipient_list], current_user)
    
    send_invitations_for(@invitations[:successful]) if !@invitations[:successful].blank?
    
    set_flash_notices_for(@invitations)
    
    redirect_back_or_default user_path(current_user)
  end
  
  private
  
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
