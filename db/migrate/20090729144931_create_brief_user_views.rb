class CreateDocumentUserViews < ActiveRecord::Migration
  def self.up
    create_table :document_user_views do |t|
      t.integer :document_id
      t.integer :user_id
      t.integer :view_count, :default => 0
      t.datetime :last_viewed_at
    end
  end

  def self.down
    drop_table :document_user_views
  end
end
