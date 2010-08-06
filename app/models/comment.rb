class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  
  after_save     :update_brief
  before_destroy :delete_timeline_events
  
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
  
end