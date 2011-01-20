class CreateWatchedDocuments < ActiveRecord::Migration
  def self.up
    create_table :watched_documents do |t|
      t.integer :document_id
      t.integer :creative_id

      t.timestamps
    end
  end

  def self.down
    drop_table :watched_documents
  end
end
