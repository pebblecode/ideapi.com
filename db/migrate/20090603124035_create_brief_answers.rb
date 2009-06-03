class CreateBriefAnswers < ActiveRecord::Migration
  def self.up
    rename_table :answers, :brief_answers
    rename_column :brief_answers, :question_id, :brief_question_id
    rename_column :brief_answers, :section_id, :brief_section_id
  end

  def self.down
    rename_column :brief_answers, :brief_section_id, :section_id
    rename_column :brief_answers, :brief_question_id, :question_id
    rename_table :brief_answers, :answers
  end
end
