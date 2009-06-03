class CreateBriefSectionBriefTemplates < ActiveRecord::Migration
  def self.up
    create_table :brief_section_brief_templates do |t|
      t.integer :brief_section_id
      t.integer :brief_template_id
    end
  end

  def self.down
    drop_table :brief_section_brief_templates
  end
end
