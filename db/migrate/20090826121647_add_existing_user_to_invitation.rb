class AddExistingUserToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :existing_user, :boolean
  end

  def self.down
    remove_column :invitations, :existing_user
  end
end
