class RemoveLoveHateCountsFromCreativeQuestions < ActiveRecord::Migration
  def self.up
    remove_column :creative_questions, :love_count
    remove_column :creative_questions, :hate_count
  end

  def self.down
    add_column :creative_questions, :hate_count, :integer,      :default => 0
    add_column :creative_questions, :love_count, :integer,      :default => 0
  end
end
