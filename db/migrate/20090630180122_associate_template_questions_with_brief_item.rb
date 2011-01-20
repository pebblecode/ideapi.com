class AssociateTemplateQuestionsWithDocumentItem < ActiveRecord::Migration
  def self.up
    add_column :document_items, :template_question_id, :integer
  end

  def self.down
    remove_column :document_items, :template_question_id
  end
end
