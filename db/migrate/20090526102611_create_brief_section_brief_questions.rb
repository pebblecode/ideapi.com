class CreateBriefSectionBriefQuestions < ActiveRecord::Migration
  def self.up
    create_table :brief_section_brief_questions do |t|
      t.integer :brief_section_id
      t.integer :brief_question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :brief_section_brief_questions
  end
end
