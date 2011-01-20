class CreateDocumentItems < ActiveRecord::Migration
  def self.up
    create_table :document_items do |t|
      t.text :title
      t.text :body
      t.integer :position
      t.integer :document_id
      t.timestamps
    end
  end

  def self.down
    drop_table :document_items
  end
end
