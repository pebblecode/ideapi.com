class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections, :force => true do |t|
      t.column :title, :string
      t.column :strapline, :text
      t.column :position, :integer
      t.integer :brief_config_id
    end
  end

  def self.down
    drop_table :sections
  end
end
