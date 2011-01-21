class UserDocument < ActiveRecord::Base
  belongs_to :document
  belongs_to :user
  belongs_to :added_by_user, :class_name => "User"
  
  named_scope :authored, :conditions => ['author = true']
  named_scope :collaborating, :conditions => ['author = false']
  
  attr_accessor :approver, :add_document
  # validates_presence_of :user, :document
  
  after_create :notify_user, :assign_approver
  after_update :notify_if_role_changed
  
  validates_uniqueness_of :user_id, :scope => :document_id
  # If we delete the approver user_document record, the document does not get updated.
  # Make sure that the approver is part of the document users, if not, set it to document author. 
  after_destroy :update_approver_if_needed
  def update_approver_if_needed
    if not self.document.users.include? self.user
      self.document.approver = self.document.author
      self.document.save
    end
  end
  
  def document_role
    return "" if self.document.nil?
    if self.author? and self.document.approver?(self.user)
      {  :label => "author, approver", 
         :log_level => 3  }
    else
      self.document.role_for_user?(self.user)
    end
  end
  
  def role
    self.author? ? "author" : "collaborator"
  end
  
  def document_author?
    document.author?(user)
  end
  
  # def destroy
  #   raise "Cannot delete the only author in a document" if (self.document.authors.count == 1 and self.document.author == self.user)
  #   super
  # end
  private
  
  def notify_user
    unless document_author?
      # As this is now being processed by Resque we need to pass
      # the id as it gets processed by a worker
      begin
        NotificationMailer.deliver_user_added_to_document(self.id) unless self.user.pending?
      rescue Errno::ECONNREFUSED
        nil
      end
    end
  end
  
  def notify_if_role_changed
    # As this is now being processed by Resque we need to pass
    # the id as it gets processed by a worker
    begin
      NotificationMailer.deliver_user_role_changed_on_document(self.id) if author_changed?
    rescue Errno::ECONNREFUSED
      nil
    end
    
    
  end
  
  # This method checks whether the virtual attribute approver
  # is true. If so it assigns the user to be an approver for
  # that document and saves the record
  def assign_approver
    if approver == "1"
      document.approver = user
      document.save!
    end
  end

end
