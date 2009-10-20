class UserBrief < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  
  named_scope :authored, :conditions => ['author = true']
  named_scope :collaborating, :conditions => ['author = false']
  
  validates_presence_of :user, :on => :create, :message => "can't be blank"
  validates_presence_of :brief, :on => :create, :message => "can't be blank"
  
end
