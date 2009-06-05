class RenameCreativeQuestionUserIds < ActiveRecord::Migration
  def self.up
    rename_column :creative_proposals, :user_id, :creative_id
    rename_column :creative_questions, :user_id, :creative_id
  end

  def self.down
    rename_column :creative_questions, :creative_id, :user_id
    rename_column :creative_proposals, :creative_id, :user_id
  end
end
