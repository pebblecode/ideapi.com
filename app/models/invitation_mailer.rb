class InvitationMailer < ActionMailer::Base
  def invitation(invitation, sent_at = Time.now)
    @subject = 'InvitationMailer#invitation'
    @body[:invitation] = invitation
    @recipients = invitation.recipient_email
    @from = 'invite@ideapi.net'
    @sent_on = sent_at
  end

  def invite_request(requested_by, sent_at = Time.now)
    @subject = '[IDEAPI] Invitation request'
    @body[:requested_by] = requested_by
    @recipients = 'alex@ideapi.net'
    @from = requested_by.email
    @sent_on = sent_at
  end

end
