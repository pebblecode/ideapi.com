class AccountOwnersView < ActiveRecord::Migration
  def self.up
    execute "create view vw_account_owners as select u.email, a.*, u.first_name, u.last_name from accounts a inner join account_users au on a.id = au.account_id inner join users u on au.user_id = u.id where au.admin = 1"
  end

  def self.down
    execute "drop view vw_account_owners"
  end
end
