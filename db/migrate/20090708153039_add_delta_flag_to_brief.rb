class AddDeltaFlagToBrief < ActiveRecord::Migration
  def self.up
    add_column :briefs, :delta, :boolean
    add_index :briefs, :delta 
  end

  def self.down
    remove_column :briefs, :delta
  end
end
