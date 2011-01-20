class AddMissingTemplateQuestionFieldsToDocumentItems < ActiveRecord::Migration
  def self.up
    # Create fields
    add_column :document_items, :help_message, :text
    add_column :document_item_versions, :help_message, :text
    add_column :document_items, :optional, :boolean
    add_column :document_item_versions, :optional, :boolean
  end

  def self.down
    remove_column :document_items, :help_message
    remove_column :document_items, :optional
    remove_column :document_item_versions, :help_message
    remove_column :document_item_versions, :optional
  end
end
