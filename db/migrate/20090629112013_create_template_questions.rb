class CreateTemplateQuestions < ActiveRecord::Migration
  def self.up
    create_table :template_questions do |t|
      t.text :body
      t.text :help_message
      t.boolean :optional
      t.integer :template_section_id
    end
  end

  def self.down
    drop_table :template_questions
  end
end
