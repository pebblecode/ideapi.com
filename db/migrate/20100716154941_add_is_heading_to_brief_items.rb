class AddIsHeadingToDocumentItems < ActiveRecord::Migration
  def self.up
    add_column :document_items, :is_heading, :boolean, :default => false
  end

  def self.down
    remove_column :document_items, :is_heading
  end
end
