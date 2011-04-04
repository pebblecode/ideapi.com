class AddTimeStampsToBriefs < ActiveRecord::Migration
  def self.up
    add_column :briefs, :updated_at, :datetime
    add_column :briefs, :created_at, :datetime
  end

  def self.down
    remove_column :briefs, :created_at
    remove_column :briefs, :updated_at
  end
end
