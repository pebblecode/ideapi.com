class AddRevisedAtToRevisions < ActiveRecord::Migration
  def self.up
    add_column :brief_item_versions, :revised_at, :datetime
  end

  def self.down
    remove_column :brief_item_versions, :revised_at
  end
end
