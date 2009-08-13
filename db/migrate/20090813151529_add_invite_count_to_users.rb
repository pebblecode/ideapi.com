class AddInviteCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invite_count, :integer
  end

  def self.down
    remove_column :users, :invite_count
  end
end
