class AddAddedByUserToUserDocuments < ActiveRecord::Migration
  def self.up
    add_column :user_documents, :added_by_user_id, :integer
  end

  def self.down
    remove_column :user_documents, :added_by_user_id
  end
end
