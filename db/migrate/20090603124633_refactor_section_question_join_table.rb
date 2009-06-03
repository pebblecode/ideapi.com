class RefactorSectionQuestionJoinTable < ActiveRecord::Migration
  def self.up
    rename_table :section_questions, :brief_section_brief_questions
    rename_column :brief_section_brief_questions, :question_id, :brief_question_id
    rename_column :brief_section_brief_questions, :section_id, :brief_section_id
  end

  def self.down
    rename_column :brief_section_brief_questions, :brief_section_id, :section_id
    rename_column :brief_section_Brief_questions, :brief_question_id, :question_id
    rename_table :brief_section_brief_questions, :section_questions
  end
end
