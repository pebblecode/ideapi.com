class CreateBriefAnswers < ActiveRecord::Migration
  def self.up
    create_table :brief_answers, :force => true do |t|
      t.column :answer, :text
      t.column :brief_question_id, :integer
      t.column :brief_id, :integer
    end
  end

  def self.down
    drop_table :brief_answers
  end
end
