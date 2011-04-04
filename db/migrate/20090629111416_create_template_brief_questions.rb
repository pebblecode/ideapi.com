class CreateTemplateBriefQuestions < ActiveRecord::Migration
  def self.up
    create_table :template_brief_questions do |t|
      t.integer :template_brief_id
      t.integer :template_question_id
    end
  end

  def self.down
    drop_table :template_brief_questions
  end
end
