class CreateBriefTemplates < ActiveRecord::Migration
  def self.up
    create_table :brief_templates do |t|
      t.string :title
      t.integer :brief_config_id

      t.timestamps
    end
  end

  def self.down
    drop_table :brief_templates
  end
end
