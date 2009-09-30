class RevoveExistingUserFromInivitation < ActiveRecord::Migration
  def self.up
    remove_column :invitations, :existing_user
  end

  def self.down
    add_column :invitations, :existing_user, :boolean,   :default => false
  end
end
