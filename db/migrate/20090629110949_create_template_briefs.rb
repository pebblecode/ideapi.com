class CreateTemplateDocuments < ActiveRecord::Migration
  def self.up
    create_table :template_documents do |t|
      t.string :title
      t.integer :site_id
    end
    
    remove_column :documents, :document_template_id
    add_column :documents, :template_document_id, :integer
  end

  def self.down
    remove_column :documents, :template_document_id
    add_column :documents, :document_template_id, :integer
    drop_table :template_documents
  end
end
