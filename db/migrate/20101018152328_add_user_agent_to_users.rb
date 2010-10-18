class AddUserAgentToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_agent_string, :text
  end

  def self.down
    remove_column :users, :user_agent_string
  end
end
