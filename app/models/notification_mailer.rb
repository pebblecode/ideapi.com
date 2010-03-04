class NotificationMailer < ActionMailer::Base

  def user_added_to_brief(user_brief, sent_at = Time.now)
    # from        "notifications@#{user_brief.brief.account.full_domain}"
    from        "#{user_brief.brief.account.subdomain}@#{AppConfig['base_config']}"
    recipients  user_brief.user.email
    # reply_to    "no-reply@#{user_brief.brief.account.full_domain}"
    reply_to    "no-reply@#{AppConfig['base_config']}"
  
    subject     "[#{user_brief.brief.account.name} ideapi] You have been added to a brief"
    body        :user_brief => user_brief
  
    sent_on sent_at    
  end
  
  def user_idea_reviewed_on_brief(proposal, sent_at = Time.now)
    # from        "notifications@#{user_brief.brief.account.full_domain}"
    from        "#{user_brief.brief.account.subdomain}@#{AppConfig['base_config']}"
    recipients  proposal.user.email
    # reply_to    "no-reply@#{proposal.brief.account.full_domain}"
    reply_to    "no-reply@#{AppConfig['base_config']}"
  
    subject     "[#{proposal.brief.account.name} ideapi] Your idea has been reviewed"
    body        :proposal => proposal, :brief => proposal.brief
  
    sent_on sent_at
  end
  
  def user_question_answered_on_brief(question, sent_at = Time.now)
    # from        "notifications@#{question.brief.account.full_domain}"
    from        "#{question.brief.account.subdomain}@#{AppConfig['base_config']}"
    recipients  question.user.email
    # reply_to    "no-reply@#{question.brief.account.full_domain}"
    reply_to    "no-reply@#{AppConfig['base_config']}"
    
    subject     "[#{question.brief.account.name} ideapi] Your question has been answered"
    body        :question => question
  
    sent_on sent_at
  end

  
  def user_role_changed_on_brief(user_brief, sent_at = Time.now)    
    # from        "notifications@#{user_brief.brief.account.full_domain}"
    from        "#{user_brief.brief.account.subdomain}@#{AppConfig['base_config']}"
    recipients  user_brief.user.email
    # reply_to    "no-reply@#{user_brief.brief.account.full_domain}"
    reply_to    "no-reply@#{AppConfig['base_config']}"
    
    subject     "[#{user_brief.brief.account.name} ideapi] You are now a #{user_brief.role}"
    body        :user_brief => user_brief
  
    sent_on sent_at
  end
  
  def to_approver_idea_submitted_on_brief(approver, proposal, sent_at = Time.now)
    # from        "notifications@#{proposal.brief.account.full_domain}"
    from        "#{proposal.brief.account.subdomain}@#{AppConfig['base_config']}"
    recipients  approver.email
    # reply_to    "no-reply@#{proposal.brief.account.full_domain}"
    reply_to    "no-reply@#{AppConfig['base_config']}"
    
    subject     "[#{proposal.brief.account.name} ideapi] An idea has been submitted for review"
    body        :proposal => proposal, :approver => approver
  
    sent_on sent_at
  end
  
  def user_invited_to_account(user, account, sent_at = Time.now)
    # from        "notifications@#{account.full_domain}"
    from          "#{account.subdomain}@#{AppConfig['base_config']}"
    recipients  user.email
    reply_to    "no-reply@#{AppConfig['base_config']}"
  
    subject     "[#{account.name} ideapi] You have been invited to an account on ideapi.com"
    body        :user => user, :account => account
  
    sent_on sent_at
  end
  # 
  # def invite_request(requested_by, sent_at = Time.now)
  #   @subject = '[IDEAPI] Invitation request'
  #   @body[:requested_by] = requested_by
  #   @recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
  #   @from = 'alex@abutcher.co.uk'
  #   @sent_on = sent_at
  # end
  # 
  # def invite_request_for_user(requested_by, recipient_email, sent_at = Time.now)
  #   @subject = '[IDEAPI] Invitation request for user'
  #   @body[:requested_by] = requested_by
  #   @body[:recipient_email] = recipient_email
  #   @recipients = 'ticket+abutcher.32755-u8cs2ma4@lighthouseapp.com'
  #   @from = 'alex@abutcher.co.uk'
  #   @sent_on = sent_at
  # end

  
  # def user_added_to_account(brief, user, sent_at = Time.now)
  #   from        "notifications@#{brief.account.full_domain}"
  #   recipients  user.email
  #   reply_to    "no-reply@#{brief.account.full_domain}"
  #   
  #   subject     "[#{brief.account.name} ideapi] You have been added to a brief"
  #   body        :brief => brief, :user => user
  #   
  #   sent_on sent_at    
  # end
  # 
  # def user_invited_to_account(brief, user, sent_at = Time.now)
  #   from        "notifications@#{brief.account.full_domain}"
  #   recipients  user.email
  #   reply_to    "no-reply@#{brief.account.full_domain}"
  #   
  #   subject     "[#{brief.account.name} ideapi] You have been added to a brief"
  #   body        :brief => brief, :user => user
  #   
  #   sent_on sent_at    
  # end
  # 

  # 
  # private
  
  
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
