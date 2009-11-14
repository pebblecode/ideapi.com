class AddBriefLimitToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :brief_limit, :integer
    add_column :subscription_plans, :brief_limit, :integer
  end

  def self.down
    remove_column :subscription_plans, :brief_limit
    remove_column :subscriptions, :brief_limit
  end
end
