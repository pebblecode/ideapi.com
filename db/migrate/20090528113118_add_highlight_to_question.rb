class AddHighlightToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :optional, :boolean, :default => false
  end

  def self.down
    remove_column :questions, :highlighted
  end
end
