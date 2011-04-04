class AddBriefTemplateToBrief < ActiveRecord::Migration
  def self.up
    add_column :briefs, :brief_template_id, :integer
  end

  def self.down
    remove_column :briefs, :brief_template_id
  end
end
