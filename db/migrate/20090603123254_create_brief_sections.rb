class CreateBriefSections < ActiveRecord::Migration
  def self.up
    rename_table :sections, :brief_sections
  end

  def self.down
    rename_table :brief_sections, :sections
  end
end
