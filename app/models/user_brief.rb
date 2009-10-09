class UserBrief < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  
  named_scope :authored, :conditions => ['author = true']
  named_scope :collaborating, :conditions => ['author = false']
  
  validates_presence_of :user_id, :brief_id
end
