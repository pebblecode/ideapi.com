class AddSectionToAnswer < ActiveRecord::Migration
  def self.up
    add_column :answers, :section_id, :integer
  end

  def self.down
    remove_column :answers, :section_id
  end
end
