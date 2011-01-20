class AddOrderingOnTemplateDocumentQuestionJoins < ActiveRecord::Migration
  def self.up
    add_column :template_document_questions, :position, :integer
  end

  def self.down
    remove_column :template_document_questions, :position
  end
end
