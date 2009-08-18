class InvitationObserver < ActiveRecord::Observer

  def after_update(invitation)    
    if invitation.previous_state == :pending
      if invitation.cancelled?
        invitation.user.invite_cancelled(invitation)
      elsif invitation.accepted?
        invitation.user.invite_accepted(invitation)
      end
    end
  end

end
