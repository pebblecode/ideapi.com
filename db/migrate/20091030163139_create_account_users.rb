class CreateAccountUsers < ActiveRecord::Migration
  def self.up
    create_table :account_users do |t|
      t.integer  "user_id"
      t.integer  "account_id"
      t.string   "code"
      t.string   "state"
      t.datetime "redeemed_at"
      t.boolean  "brief_creation", :default => false
      t.timestamps
    end
    
    add_index 'account_users', 'user_id'
    add_index 'account_users', 'account_id'
  end

  def self.down
    drop_table :account_users
  end
end
