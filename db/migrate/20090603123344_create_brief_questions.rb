class CreateBriefQuestions < ActiveRecord::Migration
  def self.up
    rename_table :questions, :brief_questions
  end

  def self.down
    rename_table :brief_questions, :questions
  end
end
