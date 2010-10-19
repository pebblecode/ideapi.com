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
  # If we delete the approver user_brief record, the brief does not get updated.
  # Make sure that the approver is part of the brief users, if not, set it to brief author. 
  after_destroy :update_approver_if_needed
  def update_approver_if_needed
    if not self.brief.users.include? self.user
      self.brief.approver = self.brief.author
      self.brief.save
    end
  end
  
  def brief_role
    return "" if self.brief.nil?
    if self.author? and self.brief.approver?(self.user)
      {  :label => "author, approver", 
         :log_level => 3  }
    else
      self.brief.role_for_user?(self.user)
    end
  end
  
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
      NotificationMailer.deliver_user_added_to_brief(self.id)
    end
  end
  
  def notify_if_role_changed
    # [DEPRECATED]
    # NotificationMailer.deliver_user_added_to_brief(self)
    # As this is now being processed by Resque we need to pass
    # the id as it gets processed by a worker
    NotificationMailer.deliver_user_role_changed_on_brief(self.id) if author_changed?
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
