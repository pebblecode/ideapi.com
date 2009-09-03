class Friendship < ActiveRecord::Base

  belongs_to :friendshipped_by_me,   
    :foreign_key => "user_id",   
    :class_name => "User"
  
  belongs_to :friendshipped_for_me,  
    :foreign_key => "friend_id", 
    :class_name => "User"

  # TODO: Add some friendly accessor methods here
  
  named_scope :pending, :conditions => "accepted_at IS NULL"

  validates_uniqueness_of :friend_id, 
    :on => :create,  
    :scope => :user_id
  
  def pending?
    accepted_at.blank?
  end

  alias :requested? :pending?


end

