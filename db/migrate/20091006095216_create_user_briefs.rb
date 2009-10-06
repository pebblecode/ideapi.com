class CreateUserBriefs < ActiveRecord::Migration
  def self.up
    create_table :user_briefs do |t|
      t.integer :brief_id
      t.integer :user_id
      t.boolean :author, :default => false
    
      t.timestamps
    end
    
    add_index :user_briefs, :brief_id
    add_index :user_briefs, :user_id
  
  end

  def self.down
    remove_index :user_briefs, :user_id
    remove_index :user_briefs, :brief_id
    
    drop_table :user_briefs
  end
end
