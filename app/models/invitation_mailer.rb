class InvitationMailer < ActionMailer::Base
  def invitation(invitation, sent_at = Time.now)
    @subject = 'InvitationMailer#invitation'
    @body[:invitation] = invitation
    @recipients = invitation.recipient_email
    @from = 'invite@ideapi.net'
    @sent_on = sent_at
  end
end
