class RefactorDocument < ActiveRecord::Migration
  def self.up
    remove_column :documents, :document_config_id
  end

  def self.down
    add_column :documents, :document_config_id, :integer
  end
end
