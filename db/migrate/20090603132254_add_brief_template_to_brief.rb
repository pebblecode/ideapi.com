class AddDocumentTemplateToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :document_template_id, :integer
  end

  def self.down
    remove_column :documents, :document_template_id
  end
end
