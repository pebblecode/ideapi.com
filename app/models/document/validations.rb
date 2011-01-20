class Document < ActiveRecord::Base

  # validations
  validates_presence_of :template_document_id, :title, :author_id, :account_id, :approver_id

  before_validation :ensure_approver_set

  def json_errors
    self.errors.full_messages
  end
  
  private 
  
  def ensure_approver_set
    self.approver = self.author unless self.approver.present?
  end

end