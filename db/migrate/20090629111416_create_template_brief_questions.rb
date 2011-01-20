class CreateTemplateDocumentQuestions < ActiveRecord::Migration
  def self.up
    create_table :template_document_questions do |t|
      t.integer :template_document_id
      t.integer :template_question_id
    end
  end

  def self.down
    drop_table :template_document_questions
  end
end
