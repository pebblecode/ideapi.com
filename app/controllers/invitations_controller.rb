class InvitationsController < ApplicationController
  
  def create
    store_location
    
    @invitations = Invitation.from_list_into_hash(params[:invitation], current_user)    

    send_invitations_for(@invitations[:successful]) if @invitations[:successful].present?
    
    set_flash_notices_for(@invitations)
    
    redirect_back_or_default user_path(current_user)
  end
  
  def show
    @invitation = Invitation.find_by_code(params[:id])
    if @invitation && @invitation.pending?
      if @invitation.existing_user? && @invitation.redeem_for_user(User.find_by_email(@invitation.recipient_email))
        
        if @invitation.redeemable.present?
          redirect_to url_for(@invitation.redeemable)
          set_flash_notices_for_redeemable(@invitation.redeemable)
        else
          redirect_back_or_default '/'
        end
      
      else
        redirect_to new_user_path(:invite => @invitation.code)
      end
    else
      flash[:error] = @invitation ? "Invitation is has already been accepted" : "Invitation is not valid"
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
  
  def request_invitations
    InvitationMailer.deliver_invite_request(current_user)
    flash[:notice] = "Your request has been sent to ideapi support"
    redirect_to user_path(current_user) 
  end
  
  def request_invitation_for_email
    store_location
    
    if Invitation.valid_email?(params[:invitation][:recipient_email])
      InvitationMailer.deliver_invite_request_for_user(current_user, params[:invitation][:recipient_email])
      flash[:notice] = "Your request has been sent to ideapi support"
    else
      flash[:error] = "Please fill in a valid email address you wish to send an invite"
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
    @flash_invitations = invitations
    if @flash_invitations[:successful].present? # ignore failed ones for now ..
      flash[:notice] = flash_invite_sent
    elsif @flash_invitations[:failed].present? 
      flash[:error] = flash_invite_failed_addresses
    else
      flash[:error] = flash_invite_failed_sending
    end
  end
  
  def flash_invite_sent
     "An invite has been sent to #{@flash_invitations[:successful].map(&:recipient_email).join(',')}"
  end
  
  def flash_invite_failed_addresses
    "Couldn't send invitation to #{@flash_invitations[:failed].map(&:recipient_email).join(',')}"
  end

  def flash_invite_failed_sending
    "There was a problem sending invitiations, please check and try again."
  end
  
  def set_flash_notices_for_redeemable(redeemable)
    flash[:note] = "#{redeemable.user.login.titleize} has invited you to collaborate on this brief. Click on &ldquo;ask question/comment&rdquo; to have your say on a section. Click the &ldquo;JOIN THE DISCUSSION&rdquo; button to see all of the contributions so far." 
  end
  
  def store_location
    session[:return_to] = request.env['HTTP_REFERER']
  end

end
