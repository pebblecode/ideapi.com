class CreateAccountTemplateBriefs < ActiveRecord::Migration
  def self.up
    create_table :account_template_briefs do |t|
      t.integer :account_id
      t.integer :template_brief_id
    end
  end

  def self.down
    drop_table :account_template_briefs
  end
end
