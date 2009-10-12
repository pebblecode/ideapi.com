class User < ActiveRecord::Base
  
  # handle invitations ..
  include Ideapi::HighSociety
  can_grant_invites_to_others :max_invites => 10, :initialise_with => 10
  
  def invite_accepted(invitation)
    if invitation.respond_to?(:redeemed_by) && invitation.redeemed_by.present?
      unless is_friends_or_pending_with?(invitation.redeemed_by)
        become_friends_with(invitation.redeemed_by) 
      end
    end
  end
  
  def invite_redeemed(invitation)
    if invitation.redeemable.present? && invitation.redeemable.is_a?(Brief)  
      watch(invitation.redeemable)
    end
  end
  
end