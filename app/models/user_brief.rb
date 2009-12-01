class UserBrief < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  belongs_to :added_by_user, :class_name => "User"
  
  named_scope :authored, :conditions => ['author = true']
  named_scope :collaborating, :conditions => ['author = false']
  
  validates_presence_of :user, :brief 
  
  after_create :notify_user
  after_update :notify_if_role_changed
  
  def role
    self.author? ? "author" : "collaborator"
  end
  
  private
  
  def notify_user
    unless brief.author?(user)
      NotificationMailer.deliver_user_added_to_brief(self)
    end
  end
  
  def notify_if_role_changed
    NotificationMailer.deliver_user_role_changed_on_brief(self) if author_changed?
  end
  
end
