class AddStateToBrief < ActiveRecord::Migration
  def self.up
    add_column :briefs, :state, :string
  end

  def self.down
    remove_column :briefs, :state
  end
end
