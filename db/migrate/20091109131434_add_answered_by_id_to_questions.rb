class AddAnsweredByIdToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :answered_by_id, :integer
  end

  def self.down
    remove_column :questions, :answered_by_id
  end
end
