class AddAccountIdToBriefs < ActiveRecord::Migration
  def self.up
    add_column :briefs, :account_id, :integer
  end

  def self.down
    remove_column :briefs, :account_id
  end
end
