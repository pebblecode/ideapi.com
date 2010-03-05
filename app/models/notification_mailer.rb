class NotificationMailer < ActionMailer::Base

  def subject(account_name, message, context = "ideapi")
    "[#{account_name} :: #{context}] #{message}"
  end
  
  def email_address(account_name)
    "#{account_name} <no-reply@#{AppConfig['base_domain']}>"
  end 
  
  def user_added_to_brief(user_brief, sent_at = Time.now)
    from        email_address(user_brief.brief.account.name)
    recipients  user_brief.user.email
    reply_to    email_address(user_brief.brief.account.name)
    subject     subject(user_brief.brief.account.name, "You have been invited to collaborate", user_brief.brief.title)
    body        :user_brief => user_brief
    sent_on     sent_at    
  end
  
  def user_idea_reviewed_on_brief(proposal, sent_at = Time.now)
    from        email_address(proposal.brief.account.name)
    recipients  proposal.user.email
    reply_to    email_address(proposal.brief.account.name)
    #subject     "[#{proposal.brief.account.name} ideapi] Your idea has been reviewed"
    subject     subject(proposal.brief.account.name, "Your idea has been reviewed", proposal.brief.title)
    body        :proposal => proposal, :brief => proposal.brief
    sent_on     sent_at
  end
  
  def user_question_answered_on_brief(question, sent_at = Time.now)
    from        email_address(question.brief.account.name)
    recipients  question.user.email
    reply_to    email_address(question.brief.account.name)
    #subject     "[#{question.brief.account.name} ideapi] Your question has been answered"
    subject     subject(question.brief.account.name, "Your question has been answered", question.brief.title)
    body        :question => question
    sent_on     sent_at
  end

  
  def user_role_changed_on_brief(user_brief, sent_at = Time.now)    
    from        email_address(user_brief.brief.account.name)
    recipients  user_brief.user.email
    reply_to    email_address(user_brief.brief.account.name)
    #subject     "[#{user_brief.brief.account.name} ideapi] You are now a #{user_brief.role}"
    subject     subject(user_brief.brief.account.name, "Your role is now #{user_brief.role}", user_brief.brief.title)
    body        :user_brief => user_brief
    sent_on     sent_at
  end
  
  def to_approver_idea_submitted_on_brief(approver, proposal, sent_at = Time.now)
    from        email_address(proposal.brief.account.name)
    recipients  approver.email
    reply_to    email_address(proposal.brief.account.name)
    #subject     "[#{proposal.brief.account.name} ideapi] An idea has been submitted for review"
    subject     subject(proposal.brief.account.name, "An idea has been submitted for review", proposal.brief.title)
    body        :proposal => proposal, :approver => approver
    sent_on     sent_at
  end
  
  def user_invited_to_account(user, account, sent_at = Time.now)
    from        email_address(account.name)
    recipients  user.email
    reply_to    email_address(account.name)
    #subject     "[#{account.name} ideapi] You have been invited to an account on ideapi.com"
    subject     subject(account.name, "You now have an ideapi.com account")
    body        :user => user, :account => account
    sent_on     sent_at
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
