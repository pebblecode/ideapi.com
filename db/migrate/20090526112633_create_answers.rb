class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers, :force => true do |t|
      t.column :body, :text
      t.column :question_id, :integer
      t.column :brief_id, :integer
    end
  end

  def self.down
    drop_table :answers
  end
end
