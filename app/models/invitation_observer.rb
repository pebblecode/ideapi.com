class InvitationObserver < ActiveRecord::Observer

  def after_update(invitation)    
    if invitation.previous_state == :pending
      if invitation.cancelled?
        invitation.user.invite_cancelled(invitation) if invitation.user.present?
      elsif invitation.accepted?
        invitation.user.invite_accepted(invitation) if invitation.user.present?
        invitation.redeemed_by.invite_redeemed(invitation) if invitation.redeemed_by.present?
      end
    end
  end

end
