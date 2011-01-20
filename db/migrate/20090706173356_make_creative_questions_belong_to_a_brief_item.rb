class MakeCreativeQuestionsBelongToADocumentItem < ActiveRecord::Migration
  def self.up
    add_column :creative_questions, :document_item_id, :integer
  end

  def self.down
    remove_column :creative_questions, :document_item_id
  end
end
