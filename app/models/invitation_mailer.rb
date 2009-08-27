class InvitationMailer < ActionMailer::Base
  def invitation(invitation, sent_at = Time.now)
    @subject = 'You have been invited to ideapi.com'
    @body[:invitation] = invitation
    @recipients = invitation.recipient_email
    @from = 'donotreply@ideapi.net'
    @sent_on = sent_at
  end

  def invite_request(requested_by, sent_at = Time.now)
    @subject = '[IDEAPI] Invitation request'
    @body[:requested_by] = requested_by
    @recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
    @from = 'alex@abutcher.co.uk'
    @sent_on = sent_at
  end
  
  def invite_request_for_user(requested_by, recipient_email, sent_at = Time.now)
    @subject = '[IDEAPI] Invitation request for user'
    @body[:requested_by] = requested_by
    @body[:recipient_email] = recipient_email
    @recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
    @from = 'alex@abutcher.co.uk'
    @sent_on = sent_at
  end

end
