class Document < ActiveRecord::Base
  
  after_update :notify_if_approver_changed
  
  def author?(user)
    self.belongs_to?(user) && user_documents.find_by_user_id(user).author?
  end
  
  def role?(user)
    role_for_user?(user)[:label]
  end
  
  def role_for_user?(user)
    if author?(user)
      Roles::AUTHOR
    elsif self.approver?(user)
      Roles::APPROVER
    else
      Roles::COLLABORATOR
    end
  end
  
  module Roles
    AUTHOR = {:log_level => 3, :label => 'author'}
    APPROVER = {:log_level => 2, :label => 'approver'}
    COLLABORATOR = {:log_level => 1, :label => 'collaborator'}
  end
  
  def proposal_list_for_user(a_user)
    returning ([]) do |user_proposals|
      user_proposals << proposals.active if author_or_approver?(a_user)
      user_proposals << proposals.for_user(a_user)
    end.flatten.uniq
  end
  
  def author_or_approver?(a_user)
    belongs_to?(a_user) || approver?(a_user)
  end
  
  def belongs_to?(a_user)
    users.authors.include?(a_user)
  end
  
  def approver?(a_user)
    a_user == approver
  end
  
  def collaborator?(a_user)
    users.include?(a_user)
  end
  
  def notify_if_approver_changed
    begin
      NotificationMailer.deliver_user_made_approver_on_document(self.id) if approver_id_changed? and not self.approver.pending? and not User.current == approver
    rescue Errno::ECONNREFUSED
      nil
    end
  end
end
