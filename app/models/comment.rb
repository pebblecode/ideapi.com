class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  
  attr_accessor :send_notifications
  
  after_save      :update_document
  after_save      :deliver_notifications
  before_destroy  :delete_timeline_events
  
  belongs_to :commentable, :polymorphic => true
  
  fires :new_comment, :on => :create,
                      :actor => :user,
                      :secondary_subject  => 'commentable', 
                      :log_level => 1

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
  
  validates_presence_of :comment
  
  private
  
  def delete_timeline_events
    TimelineEvent.find(:all, :conditions => { :subject_id => self.id, :subject_type => self.class.to_s}).each do |event|
      event.destroy
    end
  end
  
  def update_document
    if self.commentable.is_a?(Document)
      self.commentable.updated_at = Time.now
      self.commentable.save false
    end
  end
  
  def deliver_notifications
    # If the comment is on a document or a Proposal, send relevant notifications. 
    if self.send_notifications.to_i == 1
      begin
        if self.commentable.is_a?(Document)
          NotificationMailer.deliver_new_comment_on_document(self.id, document_recipients) if document_recipients.present?
        end
        if self.commentable.is_a?(Proposal)
          NotificationMailer.deliver_new_comment_on_idea(self.id, idea_recipients) if idea_recipients.present?
        end
      rescue Errno::ECONNREFUSED
        nil
      end
    end
  end
  
  def document_recipients
    self.commentable.users.collect{ |user| user.email unless user.pending? }.compact - [self.user.email]
  end
  
  def idea_recipients
    recipients = self.commentable.document.authors.collect{ |author| author.email unless author.pending? }
    recipients.push(self.commentable.document.approver.email) unless self.commentable.document.approver.pending?
    return recipients.compact.uniq - [self.user.email]
  end
  
end
