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
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  user_brief.user.email
    subject     build_subject(user_brief.brief.account.name, "You have been invited to collaborate", user_brief.brief.title)
    body        :user_brief => user_brief
    sent_on     sent_at    
  end
  
  def user_idea_reviewed_on_brief(proposal, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  proposal.user.email
    subject     build_subject(proposal.brief.account.name, "Your idea has been reviewed", proposal.brief.title)
    body        :proposal => proposal, :brief => proposal.brief
    sent_on     sent_at
  end
  
  def user_question_answered_on_brief(question, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  question.user.email
    subject     build_subject(question.brief.account.name, "Your question has been answered", question.brief.title)
    body        :question => question
    sent_on     sent_at
  end

  
  def user_role_changed_on_brief(user_brief, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  user_brief.user.email
    reply_to    email_address(user_brief.brief.account.name)
    subject     build_subject(user_brief.brief.account.name, "Your role is now #{user_brief.role}", user_brief.brief.title)
    body        :user_brief => user_brief, :brief => user_brief.brief
    sent_on     sent_at
  end
  
  def user_invited_to_account(user, account, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  user.email
    reply_to    email_address(account.name)
    subject     build_subject(account.name, "You now have an ideapi.com account", "ideapi")
    body        :user => user, :account => account
    sent_on     sent_at
  end
  
  
  def user_made_approver_on_brief(brief, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  brief.approver.email
    reply_to    email_address(brief.account.name)
    subject     build_subject(brief.account.name, "You've been made an approver", brief.title)
    body        :brief => brief
    sent_on     sent_at
    
  end
  
  def password_reset_instructions(user, account)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    subject       "Password Reset Instructions"  
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_reset_password_url(user.perishable_token, :host => account.full_domain), :account => account
  end
  
  def to_approver_idea_submitted_on_brief(approver, proposal, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  approver.email
    reply_to    email_address(proposal.brief.account.name)
    subject     build_subject(proposal.brief.account.name, "An idea has been submitted for review", proposal.brief.title)
    body        :proposal => proposal, :approver => approver
    sent_on     sent_at
  end
  
  def new_question_on_brief(question, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  question.brief.authors.collect{ |user| user.email }.compact  - [question.user.email]
    reply_to    email_address(question.brief.account.name)
    subject     build_subject(question.brief.account.name, "A question has been posted", question.brief.title)
    body        :question => question
    sent_on     sent_at
  end
  
  def new_comment_on_brief(comment, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    recipients  comment.commentable.users.collect{ |user| user.email }.compact - [comment.user.email]
    subject     build_subject(comment.commentable.account.name, "A comment has been posted", comment.commentable.title)
    body        :comment => comment
    sent_on     sent_at
  end
  
  def new_comment_on_idea(comment, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"

    # Authors and Approver
    recipients  comment.commentable.brief.authors.collect{ |author| author.email }.push(comment.commentable.brief.approver.email).compact.uniq - [comment.user.email]
    subject     build_subject(comment.commentable.brief.account.name, "A comment has been posted", comment.commentable.brief.title)
    body        :comment => comment
    sent_on     sent_at
  end
  
  def brief_section_updated(brief, updated_by, items, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"
    
    recipients  brief.users.collect{ |user| user.email }.compact - [updated_by.email]
    subject     build_subject(brief.account.name, "Brief updated", brief.title)
    body        :brief => brief, :user => updated_by, :items => items
    sent_on     sent_at
  end
  
  def brief_updated(brief, updated_by, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/html"
    
    recipients  brief.authors.collect{ |user| user.email }.compact - [updated_by.email]
    subject     build_subject(brief.account.name, "Brief updated", brief.title)
    body        :brief => brief
    sent_on     sent_at
  end

end
