class AddBriefAuthorshipToAccountUsers < ActiveRecord::Migration
  def self.up
    add_column :account_users, :can_create_briefs, :boolean, :default => false
    
    AccountUser.update_all(:can_create_briefs => false)
    AccountUser.admin.update_all(:can_create_briefs => true)
  end

  def self.down
    remove_column :account_users, :can_create_briefs
  end
end
