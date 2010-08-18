class AddMissingTemplateQuestionFieldsToBriefItems < ActiveRecord::Migration
  def self.up
    # Create fields
    add_column :brief_items, :help_message, :text
    add_column :brief_item_versions, :help_message, :text
    add_column :brief_items, :optional, :boolean
    add_column :brief_item_versions, :optional, :boolean
  end

  def self.down
    remove_column :brief_items, :help_message
    remove_column :brief_items, :optional
    remove_column :brief_item_versions, :help_message
    remove_column :brief_item_versions, :optional
  end
end
