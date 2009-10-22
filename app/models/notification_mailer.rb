class NotificationMailer < ActionMailer::Base
  
  def invitation(invitation, sent_at = Time.now)
    @subject = 'You have been invited to ideapi.com'
    @body[:invitation] = invitation
    @recipients = invitation.recipient_email
    @from = 'support@ideapi.com'
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



  def user_added_to_brief(brief, user, sent_at = Time.now)
    
    from        "notifications@#{brief.account_name}.ideapi.com"
    recipients  user.email  
    reply_to    "no-reply@#{brief.account_name}.ideapi.com"
    
    
    subject     "[#{brief.account_name} ideapi] You have been added to a brief"
    
    body        :brief => brief, :user => user
    
    
    @recipients = 
    @from = 'alex@abutcher.co.uk'
    @sent_on = sent_at    
  end
  
  private
  
  def notification_email(account)
    
  end
  
  def method_name
    
  end
  
  # def user_role_changed(sent_at = Time.now)
  #   @subject = '[IDEAPI] Invitation request for user'
  #   @body[:requested_by] = requested_by
  #   @body[:recipient_email] = recipient_email
  #   @recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
  #   @from = 'alex@abutcher.co.uk'
  #   @sent_on = sent_at
  # end
  # 
  # def user_idea_reviewed(sent_at = Time.now)
  #   @subject = '[IDEAPI] Invitation request for user'
  #   @body[:requested_by] = requested_by
  #   @body[:recipient_email] = recipient_email
  #   @recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
  #   @from = 'alex@abutcher.co.uk'
  #   @sent_on = sent_at
  # end
  # 
  # def user_question_answered(sent_at = Time.now)
  #   @subject = '[IDEAPI] Invitation request for user'
  #   @body[:requested_by] = requested_by
  #   @body[:recipient_email] = recipient_email
  #   @recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
  #   @from = 'alex@abutcher.co.uk'
  #   @sent_on = sent_at
  # end
  # 
  # def user_idea_submitted(sent_at = Time.now)
  #   @subject = '[IDEAPI] Invitation request for user'
  #   @body[:requested_by] = requested_by
  #   @body[:recipient_email] = recipient_email
  #   @recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
  #   @from = 'alex@abutcher.co.uk'
  #   @sent_on = sent_at
  # end
      
end
