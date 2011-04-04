class RefactorRemovingRoles < ActiveRecord::Migration
  def self.up
    rename_table :creative_questions, :questions
    rename_table :creative_proposals, :proposals
    rename_column :proposals, :creative_id, :user_id
    rename_column :questions, :creative_id, :user_id
    rename_column :briefs, :author_id, :user_id
    rename_column :watched_briefs, :creative_id, :user_id
  end

  def self.down
    rename_column :watched_briefs, :user_id, :creative_id
    rename_column :briefs, :user_id, :author_id
    rename_column :questions, :user_id, :creative_id
    rename_column :proposals, :user_id, :creative_id
    rename_table :proposals, :creative_proposals
    rename_table :questions, :creative_questions
  end
end
