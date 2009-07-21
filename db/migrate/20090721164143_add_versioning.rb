class AddVersioning < ActiveRecord::Migration
  def self.up
    BriefItem.create_versioned_table
  end

  def self.down
    BriefItem.drop_versioned_table
  end
end
