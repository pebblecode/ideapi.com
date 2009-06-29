class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :login, :string
      t.column :email, :string
      t.column :crypted_password, :string
      t.column :password_salt, :string
      t.column :persistence_token, :string
      t.string :type
    end
  end

  def self.down
    drop_table :users
  end
end
