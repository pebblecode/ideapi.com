class RefactorBrief < ActiveRecord::Migration
  def self.up
    remove_column :briefs, :brief_config_id
  end

  def self.down
    add_column :briefs, :brief_config_id, :integer
  end
end
