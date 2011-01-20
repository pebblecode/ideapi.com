class NotificationMailer < ActionMailer::Base

  # Queue mail deliver with Resque
  # See http://github.com/zapnap/resque_mailer
  include Resque::Mailer
  
  def build_subject(account_name, message, context)
    "[#{account_name} :: #{context}] #{message}"
  end
  
  def email_address(account_name, simple = false)
    if simple
      "no-reply@ideapi.com"
    else
      "#{account_name} <no-reply@ideapi.com>"
    end
  end
  
  # Need to add "return-path" headers because of a bug in rails' smtp mailer
  # It seems to use from address as return-path and returns a syntax error.
  # Fixed in rails 3.x
  
  def user_added_to_document(user_document_id, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @user_document = UserDocument.find_by_id(user_document_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  @user_document.user.email
    subject     build_subject(@user_document.document.account.name, "You have been invited to collaborate", @user_document.document.title)
    body        :user_document => @user_document
    sent_on     sent_at    
  end
  
  def user_idea_reviewed_on_document(proposal_id, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @proposal = Proposal.find_by_id(proposal_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  @proposal.user.email
    subject     build_subject(@proposal.document.account.name, "Your idea has been reviewed", @proposal.document.title)
    body        :proposal => @proposal, :document => @proposal.document
    sent_on     sent_at
  end
  
  def user_question_answered_on_document(question_id, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @question = Question.find_by_id(question_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  @question.user.email
    subject     build_subject(@question.document.account.name, "Your question has been answered", @question.document.title)
    body        :question => @question
    sent_on     sent_at
  end

  
  def user_role_changed_on_document(user_document_id, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @user_document = UserDocument.find_by_id(user_document_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  @user_document.user.email
    subject     build_subject(@user_document.document.account.name, "Your role is now #{@user_document.role}", @user_document.document.title)
    body        :user_document => @user_document, :document => @user_document.document
    sent_on     sent_at
  end
  
  def user_invited_to_account(user_id, account_id, invitation_message = "", sent_at = Time.now)
    # We need to look these up so we can process mail with Resque
    @user = User.find_by_id(user_id)
    @account = Account.find_by_id(account_id)
    @user.invitation_message = invitation_message
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  @user.email
    subject     build_subject(@account.name, "You now have an ideapi.com account", "ideapi")
    body        :user => @user, :account => @account
    sent_on     sent_at
  end
  
  
  def user_added_to_account(user_id, account_id, invitation_message, sent_at = Time.now)
    # We need to look these up so we can process mail with Resque
    @user = User.find_by_id(user_id)
    @account = Account.find_by_id(account_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  @user.email
    subject     build_subject(@account.name, "You've been invited to an ideapi.com account", "ideapi")
    body        :user => @user, :account => @account
    sent_on     sent_at
  end

  def user_made_approver_on_document(document_id, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @document = Document.find_by_id(document_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  @document.approver.email
    subject     build_subject(@document.account.name, "You've been made an approver", @document.title)
    body        :document => @document
    sent_on     sent_at
    
  end
  
  def password_reset_instructions(user_id, account_id)
    # We need to look these up so we can process mail with Resque
    @user = User.find_by_id(user_id)
    @account = Account.find_by_id(account_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    subject       "Password Reset Instructions"  
    recipients    @user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_reset_password_url(@user.perishable_token, :host => @account.full_domain), :account => @account
  end
  
  def to_approver_idea_submitted_on_document(approver_id, proposal_id, sent_at = Time.now)
    # We need to look these up so can process mail with Resque
    @approver = User.find_by_id(approver_id)
    @proposal = Proposal.find_by_id(proposal_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  @approver.email
    subject     build_subject(@proposal.document.account.name, "An idea has been submitted for review", @proposal.document.title)
    body        :proposal => @proposal, :approver => @approver
    sent_on     sent_at
  end
  
  def new_question_on_document(question_id, recipients, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @question = Question.find_by_id(question_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  recipients
    subject     build_subject(@question.document.account.name, "A question has been posted", @question.document.title)
    body        :question => @question
    sent_on     sent_at
  end
  
  def new_comment_on_document(comment_id, recipients, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @comment = Comment.find_by_id(comment_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    recipients  recipients
    subject     build_subject(@comment.commentable.account.name, "A comment has been posted", @comment.commentable.title)
    body        :comment => @comment
    sent_on     sent_at
  end
  
  def new_comment_on_idea(comment_id, recipients, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @comment = Comment.find_by_id(comment_id)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"

    # Authors and Approver
    recipients  recipients
    subject     build_subject(@comment.commentable.document.account.name, "A comment has been posted", @comment.commentable.document.title)
    body        :comment => @comment
    sent_on     sent_at
  end
  
  def document_section_updated(document_id, recipients, updated_by_id, items, sent_at = Time.now)
    # We need to look this up so we can process mail with Resque
    @document = Document.find_by_id(document_id)
    @updated_by = User.find_by_id(updated_by_id)
    @items = DocumentItem.find(items)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"
    
    recipients  recipients
    subject     build_subject(@document.account.name, "Document updated", @document.title)
    body        :document => @document, :user => @updated_by, :items => @items
    sent_on     sent_at
  end
  
  # This mailer doesn't seem to be used any more?
  def document_updated(document, updated_by, sent_at = Time.now)
    from      email_address("ideapi")
    headers   "return-path" => 'no-reply@ideapi.com'
    reply_to  "no-reply@ideapi.com"
    content_type "text/plain"
    
    recipients  document.authors.collect{ |user| user.email }.compact - [updated_by.email]
    subject     build_subject(document.account.name, "Document updated", document.title)
    body        :document => document
    sent_on     sent_at
  end

end
