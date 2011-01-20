class MoveDocumentOwnerToAuthor < ActiveRecord::Migration
  def self.up
    rename_column :documents, :user_id, :author_id
  end

  def self.down
    rename_column :documents, :author_id, :user_id
  end
end
