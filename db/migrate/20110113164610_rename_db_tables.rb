class RenameDbTables < ActiveRecord::Migration
  def self.up
    rename_table :account_template_briefs, :account_template_documents
    rename_table :brief_item_versions, :document_item_versions
    rename_table :brief_items, :document_items
    rename_table :briefs, :documents
    rename_table :template_brief_questions, :document_brief_questions
    rename_table :template_briefs, :document_briefs
    rename_table :user_briefs, :user_documents
  end

  def self.down
    rename_table :account_template_documents, :account_template_briefs
    rename_table :document_item_versions, :brief_item_versions
    rename_table :document_items, :brief_items
    rename_table :documents, :briefs
    rename_table :document_brief_questions, :template_brief_questions
    rename_table :document_briefs, :template_briefs
    rename_table :user_documents, :user_briefs
  end
end
