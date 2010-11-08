class UserLimits < ActiveRecord::Migration
  def self.up
    execute "update subscription_plans set user_limit = NULL where name = 'Free' and amount = 0.00"
    execute 'update subscriptions set user_limit = NULL where user_limit = 10'
  end

  def self.down
    execute "update subscription_plans set user_limit = 10 where name = 'Free' and amount = 0.00"
  end
end
