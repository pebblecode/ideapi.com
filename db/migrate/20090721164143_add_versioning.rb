class AddVersioning < ActiveRecord::Migration
  def self.up
    DocumentItem.create_versioned_table
  end

  def self.down
    DocumentItem.drop_versioned_table
  end
end
