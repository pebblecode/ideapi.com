class CreateCreativeQuestions < ActiveRecord::Migration
  def self.up
    create_table :creative_questions do |t|
      t.text :body
      t.text :author_answer
      t.integer :document_id
      t.integer :creative_id
      t.timestamps
    end
  end

  def self.down
    drop_table :creative_questions
  end
end
