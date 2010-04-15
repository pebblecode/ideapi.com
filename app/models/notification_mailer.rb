class NotificationMailer < ActionMailer::Base

  def build_subject(account_name, message, context)
    "[#{account_name} :: #{context}] #{message}"
  end
  
  def email_address(account_name, simple = false)
    if simple
      "support@ideapi.com"
    else
      "#{account_name} <support@ideapi.com>"
    end
  end 
  # Need to add "return-path" headers because of a bug in rails' smtp mailer
  # It seems to use from address as return-path and returns a syntax error.
  # Fixed in rails 3.x
  
  def user_added_to_brief(user_brief, sent_at = Time.now)
    from        email_address(user_brief.brief.account.name)
    # headers needed 
    headers     "return-path" => 'support@ideapi.com'
    recipients  user_brief.user.email
    reply_to    email_address(user_brief.brief.account.name)
    subject     build_subject(user_brief.brief.account.name, "You have been invited to collaborate", user_brief.brief.title)
    body        :user_brief => user_brief
    sent_on     sent_at    
  end
  
  def user_idea_reviewed_on_brief(proposal, sent_at = Time.now)
    from        email_address(proposal.brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  proposal.user.email
    reply_to    email_address(proposal.brief.account.name)
    subject     build_subject(proposal.brief.account.name, "Your idea has been reviewed", proposal.brief.title)
    body        :proposal => proposal, :brief => proposal.brief
    sent_on     sent_at
  end
  
  def user_question_answered_on_brief(question, sent_at = Time.now)
    from        email_address(question.brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  question.user.email
    reply_to    email_address(question.brief.account.name)
    subject     build_subject(question.brief.account.name, "Your question has been answered", question.brief.title)
    body        :question => question
    sent_on     sent_at
  end

  
  def user_role_changed_on_brief(user_brief, sent_at = Time.now)    
    from        email_address(user_brief.brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  user_brief.user.email
    reply_to    email_address(user_brief.brief.account.name)
    subject     build_subject(user_brief.brief.account.name, "Your role is now #{user_brief.role}", user_brief.brief.title)
    body        :user_brief => user_brief
    sent_on     sent_at
  end
  
  def to_approver_idea_submitted_on_brief(approver, proposal, sent_at = Time.now)
    from        email_address(proposal.brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  approver.email
    reply_to    email_address(proposal.brief.account.name)
    subject     build_subject(proposal.brief.account.name, "An idea has been submitted for review", proposal.brief.title)
    body        :proposal => proposal, :approver => approver
    sent_on     sent_at
  end
  
  def user_invited_to_account(user, account, sent_at = Time.now)
    from        email_address(account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  user.email
    reply_to    email_address(account.name)
    subject     build_subject(account.name, "You now have an ideapi.com account", "ideapi")
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
