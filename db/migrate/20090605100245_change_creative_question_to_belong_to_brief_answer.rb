class ChangeCreativeQuestionToBelongToBriefAnswer < ActiveRecord::Migration
  def self.up
    rename_column :creative_questions, :brief_id, :brief_answer_id
  end

  def self.down
    rename_column :creative_questions, :brief_answer_id, :brief_id
  end
end
