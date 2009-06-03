class CreateCreativeQuestions < ActiveRecord::Migration
  def self.up
    create_table :creative_questions do |t|
      t.text :body
      t.integer :love_count, :default => 0
      t.integer :hate_count, :default => 0
      t.text :answer
      t.integer :user_id
      t.integer :brief_id

      t.timestamps
    end
  end

  def self.down
    drop_table :creative_questions
  end
end
