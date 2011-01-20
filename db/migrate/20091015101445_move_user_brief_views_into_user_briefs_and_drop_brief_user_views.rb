class MoveUserDocumentViewsIntoUserDocumentsAndDropDocumentUserViews < ActiveRecord::Migration
  def self.up
    remove_index :document_user_views, :user_id
    remove_index :document_user_views, :document_id
    
    drop_table :document_user_views

    add_column :user_documents, :view_count, :integer, :default => 0
    add_column :user_documents, :last_viewed_at, :datetime
  end

  def self.down
    create_table "document_user_views", :force => true do |t|
      t.integer  "document_id"
      t.integer  "user_id"
      t.integer  "view_count",     :default => 0
      t.datetime "last_viewed_at"
    end
    
    add_index :document_user_views, :document_id
    add_index :document_user_views, :user_id
      
    remove_column :user_documents, :last_viewed_at
    remove_column :user_documents, :view_count
  end
end
