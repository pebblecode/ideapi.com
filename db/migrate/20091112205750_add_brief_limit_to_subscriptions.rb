class AddDocumentLimitToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :document_limit, :integer
    add_column :subscription_plans, :document_limit, :integer
  end

  def self.down
    remove_column :subscription_plans, :document_limit
    remove_column :subscriptions, :document_limit
  end
end
