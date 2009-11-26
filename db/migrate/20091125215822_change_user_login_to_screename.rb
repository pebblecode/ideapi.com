class ChangeUserLoginToScreename < ActiveRecord::Migration
  def self.up
    rename_column :users, :login, :screename
  end

  def self.down
    rename_column :users, :screename, :login
  end
end
