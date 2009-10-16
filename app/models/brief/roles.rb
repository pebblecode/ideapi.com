class Brief < ActiveRecord::Base

  def author?(user)
    self.belongs_to?(user) && user_briefs.find_by_user_id(user).author?
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
    if author_or_approver?(a_user)
      proposals.active
    else
      proposals.for_user(a_user)
    end
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

end