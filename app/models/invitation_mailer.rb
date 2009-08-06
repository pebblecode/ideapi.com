class InvitationMailer < ActionMailer::Base

  def invitation(email, invitation, sent_at = Time.now)
    @subject = 'InvitationMailer#invitation'
    @body[:invitation] = invitation
    @recipients = email
    @from = 'mailer@mydomain'
    @sent_on = sent_at
  end
end
