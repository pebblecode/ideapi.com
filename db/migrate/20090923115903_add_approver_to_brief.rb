class AddApproverToBrief < ActiveRecord::Migration
  def self.up
    add_column :proposals, :approver_id, :integer
  end

  def self.down
    remove_column :proposals, :approver_id
  end
end
