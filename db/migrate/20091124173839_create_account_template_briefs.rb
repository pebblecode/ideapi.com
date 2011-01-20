class CreateAccountTemplateDocuments < ActiveRecord::Migration
  def self.up
    create_table :account_template_documents do |t|
      t.integer :account_id
      t.integer :template_document_id
    end
  end

  def self.down
    drop_table :account_template_documents
  end
end
