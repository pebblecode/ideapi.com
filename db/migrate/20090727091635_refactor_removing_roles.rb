class RefactorRemovingRoles < ActiveRecord::Migration
  def self.up
    rename_table :creative_questions, :questions
    rename_table :creative_proposals, :proposals
    rename_column :proposals, :creative_id, :user_id
    rename_column :questions, :creative_id, :user_id
    rename_column :documents, :author_id, :user_id
    rename_column :watched_documents, :creative_id, :user_id
  end

  def self.down
    rename_column :watched_documents, :user_id, :creative_id
    rename_column :documents, :user_id, :author_id
    rename_column :questions, :user_id, :creative_id
    rename_column :proposals, :user_id, :creative_id
    rename_table :proposals, :creative_proposals
    rename_table :questions, :creative_questions
  end
end
