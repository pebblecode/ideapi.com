class AddAccountIdToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :account_id, :integer
  end

  def self.down
    remove_column :documents, :account_id
  end
end
