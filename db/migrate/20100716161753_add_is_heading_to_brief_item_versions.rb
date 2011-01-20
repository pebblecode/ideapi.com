class AddIsHeadingToDocumentItemVersions < ActiveRecord::Migration
  def self.up
    add_column :document_item_versions, :is_heading, :boolean, :default => false
  end

  def self.down
    remove_column :document_item_versions, :is_heading
  end
end
