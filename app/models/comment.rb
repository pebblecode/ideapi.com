class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true
  
  fires :new_comment, :on => :create,
                      :actor => :user,
                      :secondary_subject  => 'commentable'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
  
  validates_presence_of :comment

end