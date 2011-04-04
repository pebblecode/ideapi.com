class AddMostImportantMessage < ActiveRecord::Migration
  def self.up
    add_column :briefs, :most_important_message, :text
  end

  def self.down
    remove_column :briefs, :most_important_message
  end
end
