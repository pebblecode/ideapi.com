class CreateBriefItems < ActiveRecord::Migration
  def self.up
    create_table :brief_items do |t|
      t.text :title
      t.text :body
      t.integer :position
      t.integer :brief_id
      t.timestamps
    end
  end

  def self.down
    drop_table :brief_items
  end
end
