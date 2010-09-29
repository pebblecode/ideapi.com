class UserBrief < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  belongs_to :added_by_user, :class_name => "User"
  
  named_scope :authored, :conditions => ['author = true']
  named_scope :collaborating, :conditions => ['author = false']
  
  attr_accessor :approver, :add_brief
  # validates_presence_of :user, :brief
  
  after_create :notify_user, :assign_approver
  after_update :notify_if_role_changed
  
  validates_uniqueness_of :user_id, :scope => :brief_id
  
  def role
    self.author? ? "author" : "collaborator"
  end
  
  def brief_author?
    brief.author?(user)
  end
  
  
  private
  
  def notify_user
    unless brief_author?
      # [DEPRECATED]
      # NotificationMailer.deliver_user_added_to_brief(self)
      # As this is now being processed by Resque we need to pass
      # the id as it gets processed by a worker
      NotificationMailer.deliver_user_added_to_brief(self.id) unless self.user.pending?
    end
  end
  
  def notify_if_role_changed
    # [DEPRECATED]
    # NotificationMailer.deliver_user_added_to_brief(self)
    # As this is now being processed by Resque we need to pass
    # the id as it gets processed by a worker
    NotificationMailer.deliver_user_role_changed_on_brief(self.id) if author_changed? and not self.user.pending?
  end
  
  # This method checks whether the virtual attribute approver
  # is true. If so it assigns the user to be an approver for
  # that brief and saves the record
  def assign_approver
    if approver == "1"
      brief.approver = user
      brief.save!
    end
  end

end
