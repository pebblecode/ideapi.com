class AddDocumentAuthorshipToAccountUsers < ActiveRecord::Migration
  def self.up
    add_column :account_users, :can_create_documents, :boolean, :default => false
    
    AccountUser.update_all(:can_create_documents => false)
    AccountUser.admin.update_all(:can_create_documents => true)
  end

  def self.down
    remove_column :account_users, :can_create_documents
  end
end
