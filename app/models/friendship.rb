class Friendship < ActiveRecord::Base

  belongs_to :friendshipped_by_me,   
    :foreign_key => "user_id",   
    :class_name => "User"
  
  belongs_to :friendshipped_for_me,  
    :foreign_key => "friend_id", 
    :class_name => "User"

  # TODO: Add some friendly accessor methods here
  
  named_scope :pending, :conditions => "accepted_at IS NULL"
  named_scope :accepted, :conditions => "accepted_at IS NOT NULL"

  validates_uniqueness_of :friend_id, 
    :on => :create,  
    :scope => :user_id
  
  def pending?
    accepted_at.blank?
  end
  
  def accepted?
    accepted_at.present?
  end

  alias :requested? :pending?
  alias :friend :friendshipped_for_me
  alias :user :friendshipped_by_me


end

