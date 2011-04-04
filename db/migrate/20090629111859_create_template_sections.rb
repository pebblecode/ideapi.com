class CreateTemplateSections < ActiveRecord::Migration
  def self.up
    create_table :template_sections do |t|
      t.text :title
      t.integer :position
    end
  end

  def self.down
    drop_table :template_brief_sections
  end
end
