class RemoveAssocBetweenUserAndBrief < ActiveRecord::Migration
  def self.up
    remove_index :briefs, :user_id
    remove_column :briefs, :user_id
  end

  def self.down
    add_column :briefs, :user_id, :integer
    add_index :briefs, :user_id
  end
end
