class AddLevelToSectionQuestions < ActiveRecord::Migration
  def self.up
    add_column :section_questions, :position, :integer
  end

  def self.down
    remove_column :section_questions, :position
  end
end
