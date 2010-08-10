class UserBrief < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  belongs_to :added_by_user, :class_name => "User"
  
  named_scope :authored, :conditions => ['author = true']
  named_scope :collaborating, :conditions => ['author = false']
  
  attr_accessor :approver, :add_brief
  #validates_presence_of :user, :brief
  
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
      NotificationMailer.deliver_user_added_to_brief(self)
    end
  end
  
  def notify_if_role_changed
    NotificationMailer.deliver_user_role_changed_on_brief(self) if author_changed?
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

#  def assign_can_create_briefs
#    if can_create_briefs == "1"
#      a = AccountUser.find_by_account_id_and_user_id(user, brief.account).can_create_briefs = 1
#      a.save!
#      
#    end
#  end
end
