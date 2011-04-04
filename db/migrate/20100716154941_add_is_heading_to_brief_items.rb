class AddIsHeadingToBriefItems < ActiveRecord::Migration
  def self.up
    add_column :brief_items, :is_heading, :boolean, :default => false
  end

  def self.down
    remove_column :brief_items, :is_heading
  end
end
