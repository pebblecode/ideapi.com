class AddApproverToBrief < ActiveRecord::Migration
  def self.up
    add_column :briefs, :approver_id, :integer
  end

  def self.down
    remove_column :briefs, :approver_id
  end
end
