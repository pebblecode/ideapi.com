class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  
  after_save      :update_brief
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
  
  def update_brief
    if self.commentable.is_a?(Brief)
      self.commentable.updated_at = Time.now
      self.commentable.save false
    end
  end
  
  def deliver_notifications
    # If the comment is on a brief or a Proposal, send relevant notifications. 

    if self.commentable.is_a?(Brief)
      # should be sent to brief users (all collaborators)

      # [DEPRECATED]
      # NotificationMailer.deliver_new_comment_on_brief(self, brief_recipients) if brief_recipients.present?
      # We are using Resque to process emails so need to send id to worker
      NotificationMailer.deliver_new_comment_on_brief(self.id, brief_recipients) if brief_recipients.present?
    end
  
    if self.commentable.is_a?(Proposal)
      # should be sent to idea.brief.authors and idea.brief.approver
      # [DEPRECATED]
      # NotificationMailer.deliver_new_comment_on_idea(self, idea_recipients) if idea_recipients.present?
      # We are using Resque to process emails so need to send id to worker
      NotificationMailer.deliver_new_comment_on_idea(self.id, idea_recipients) if idea_recipients.present?
    end
    
  end
  
  def brief_recipients
    self.commentable.users.collect{ |user| user.email }.compact - [self.user.email]
  end
  
  def idea_recipients
    self.commentable.brief.authors.collect{ |author| author.email }.push(self.commentable.brief.approver.email).compact.uniq - [self.user.email]
  end
  
end
