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
  
  def user_invited_to_account(user, account, sent_at = Time.now)
    from        email_address(account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  user.email
    reply_to    email_address(account.name)
    subject     build_subject(account.name, "You now have an ideapi.com account", "ideapi")
    body        :user => user, :account => account
    sent_on     sent_at
  end
  
  
  def user_made_approver_on_brief(brief, sent_at = Time.now)
    from        email_address(brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  brief.approver.email
    reply_to    email_address(brief.account.name)
    subject     build_subject(brief.account.name, "You've been made an approver", brief.title)
    body        :brief => brief
    sent_on     sent_at
  end
  
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
  
  def password_reset_instructions(user)  
    default_url_options[:host] = "surestack.example.com"
    default_url_options[:port] = 3000
    
    subject       "Password Reset Instructions"  
    from          "ideapi "
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_reset_password_url(user.perishable_token)
  end
  
  
  # Notifications for Brief updates, comments, etc.
  
  def to_approver_idea_submitted_on_brief(approver, proposal, sent_at = Time.now)
    from        email_address(proposal.brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  approver.email
    reply_to    email_address(proposal.brief.account.name)
    subject     build_subject(proposal.brief.account.name, "An idea has been submitted for review", proposal.brief.title)
    body        :proposal => proposal, :approver => approver
    sent_on     sent_at
  end
  
  def new_question_on_brief(question, sent_at = Time.now)
    from        email_address(question.brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  question.brief.users.collect{ |user| user.email }.compact
    reply_to    email_address(question.brief.account.name)
    subject     build_subject(question.brief.account.name, "A question has been posted", question.brief.title)
    body        :question => question
    sent_on     sent_at
  end
  
  def new_comment_on_brief(comment, sent_at = Time.now)
    # If commentable is not a brief, this fails. 
    from        email_address(comment.commentable.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  comment.commentable.users.collect{ |user| user.email }.compact
    reply_to    email_address(comment.commentable.account.name)
    subject     build_subject(comment.commentable.account.name, "A comment has been posted", comment.commentable.title)
    body        :comment => comment
    sent_on     sent_at
  end
  
  def new_comment_on_idea(comment, sent_at = Time.now)
    from        email_address(comment.commentable.brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    # Authors and Approver
    recipients  comment.commentable.brief.authors.collect{ |author| author.email }.push(comment.commentable.brief.approver.email).compact
    reply_to    email_address(comment.commentable.brief.account.name)
    subject     build_subject(comment.commentable.brief.account.name, "A comment has been posted", comment.commentable.brief.title)
    body        :comment => comment
    sent_on     sent_at
  end
  
  def brief_section_updated(brief, user, items, sent_at = Time.now)
    from        email_address(brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  brief.users.collect{ |user| user.email }.compact
    reply_to    email_address(brief.account.name)
    subject     build_subject(brief.account.name, "Brief updated", brief.title)
    body        :brief => brief, :user => user, :items => items
    sent_on     sent_at
  end
  
  def brief_updated(brief, sent_at = Time.now)
    from        email_address(brief.account.name)
    headers     "return-path" => 'support@ideapi.com'
    recipients  brief.users.collect{ |user| user.email }.compact
    reply_to    email_address(brief.account.name)
    subject     build_subject(brief.account.name, "Brief updated", brief.title)
    body        :brief => brief
    sent_on     sent_at
  end
  
end
