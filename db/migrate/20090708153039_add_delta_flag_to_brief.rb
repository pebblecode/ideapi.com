class AddDeltaFlagToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :delta, :boolean
    add_index :documents, :delta 
  end

  def self.down
    remove_column :documents, :delta
  end
end
