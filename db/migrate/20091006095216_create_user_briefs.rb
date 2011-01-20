class CreateUserDocuments < ActiveRecord::Migration
  def self.up
    create_table :user_documents do |t|
      t.integer :document_id
      t.integer :user_id
      t.boolean :author, :default => false
    
      t.timestamps
    end
    
    add_index :user_documents, :document_id
    add_index :user_documents, :user_id
  
  end

  def self.down
    remove_index :user_documents, :user_id
    remove_index :user_documents, :document_id
    
    drop_table :user_documents
  end
end
