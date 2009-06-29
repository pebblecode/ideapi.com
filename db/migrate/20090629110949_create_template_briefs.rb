class CreateTemplateBriefs < ActiveRecord::Migration
  def self.up
    create_table :template_briefs do |t|
      t.string :title
      t.integer :site_id
    end
    
    remove_column :briefs, :brief_template_id
    add_column :briefs, :template_brief_id, :integer
  end

  def self.down
    remove_column :briefs, :template_brief_id
    add_column :briefs, :brief_template_id, :integer
    drop_table :template_briefs
  end
end
