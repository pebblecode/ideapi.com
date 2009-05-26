class CreateBriefQuestions < ActiveRecord::Migration
  def self.up
    create_table :brief_questions, :force => true do |t|
      t.column :title, :string
      t.column :help_text, :text
      t.column :response_type_id, :integer
    end
  end

  def self.down
    drop_table :brief_questions
  end
end
