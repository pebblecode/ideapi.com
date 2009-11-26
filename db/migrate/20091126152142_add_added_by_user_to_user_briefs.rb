class AddAddedByUserToUserBriefs < ActiveRecord::Migration
  def self.up
    add_column :user_briefs, :added_by_user_id, :integer
  end

  def self.down
    remove_column :user_briefs, :added_by_user_id
  end
end
