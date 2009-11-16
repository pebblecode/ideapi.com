class AddMetaToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :job_title, :string
    add_column :users, :telephone, :string
    add_column :users, :telephone_ext, :string
    add_column :users, :current_login_at, :datetime
  end

  def self.down
    remove_column :users, :current_login_at
    remove_column :users, :telephone_ext
    remove_column :users, :telephone
    remove_column :users, :job_title
  end
end
