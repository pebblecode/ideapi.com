class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents, :force => true do |t|
      t.string :title
      t.column :document_config_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :documents
  end
end
