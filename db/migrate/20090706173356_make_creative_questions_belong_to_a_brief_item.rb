class MakeCreativeQuestionsBelongToABriefItem < ActiveRecord::Migration
  def self.up
    add_column :creative_questions, :brief_item_id, :integer
  end

  def self.down
    remove_column :creative_questions, :brief_item_id
  end
end
