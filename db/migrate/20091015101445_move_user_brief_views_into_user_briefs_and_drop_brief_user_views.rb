class MoveUserBriefViewsIntoUserBriefsAndDropBriefUserViews < ActiveRecord::Migration
  def self.up
    remove_index :brief_user_views, :user_id
    remove_index :brief_user_views, :brief_id
    
    drop_table :brief_user_views

    add_column :user_briefs, :view_count, :integer, :default => 0
    add_column :user_briefs, :last_viewed_at, :datetime
  end

  def self.down
    create_table "brief_user_views", :force => true do |t|
      t.integer  "brief_id"
      t.integer  "user_id"
      t.integer  "view_count",     :default => 0
      t.datetime "last_viewed_at"
    end
    
    add_index :brief_user_views, :brief_id
    add_index :brief_user_views, :user_id
      
    remove_column :user_briefs, :last_viewed_at
    remove_column :user_briefs, :view_count
  end
end
