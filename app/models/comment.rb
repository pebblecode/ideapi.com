class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  validates_uniqueness_of :comment, :if => :protect_flood_post
  
  validates_presence_of :comment, :user
  
  acts_as_nested_set
  
  def top_level?
    root? || parent_id.blank?
  end
  
  named_scope :top_level, :conditions => "parent_id IS NULL"
  
  private
  
  def protect_flood_post
    self.user && self.user.commented_recently?
  end
  
end