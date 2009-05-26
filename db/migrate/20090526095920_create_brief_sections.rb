class CreateBriefSections < ActiveRecord::Migration
  def self.up
    create_table :brief_sections, :force => true do |t|
      t.column :title, :string
      t.column :strapline, :text
      t.column :position, :integer
    end
  end

  def self.down
    drop_table :brief_sections
  end
end
