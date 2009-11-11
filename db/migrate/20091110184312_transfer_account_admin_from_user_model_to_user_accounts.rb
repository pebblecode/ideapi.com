class TransferAccountAdminFromUserModelToUserAccounts < ActiveRecord::Migration
  def self.up
    remove_column :users, :account_id
    remove_column :users, :admin
    
    add_column :account_users, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :account_users, :admin
    add_column :users, :admin, :boolean,               :default => false
    add_column :users, :account_id, :integer
  end
end
