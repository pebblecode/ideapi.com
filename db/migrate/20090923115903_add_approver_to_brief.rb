class AddApproverToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :approver_id, :integer
  end

  def self.down
    remove_column :documents, :approver_id
  end
end
