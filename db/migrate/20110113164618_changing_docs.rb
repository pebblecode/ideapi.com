class ChangingDocs < ActiveRecord::Migration
  def self.up
    execute 'delete from template_document_questions where template_document_id = 1'
  end

  def self.down
  end
end
