class CreateSectionQuestions < ActiveRecord::Migration
  def self.up
    create_table :section_questions do |t|
      t.integer :section_id
      t.integer :question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :section_questions
  end
end
