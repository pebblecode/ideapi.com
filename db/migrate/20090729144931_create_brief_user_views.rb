class CreateBriefUserViews < ActiveRecord::Migration
  def self.up
    create_table :brief_user_views do |t|
      t.integer :brief_id
      t.integer :user_id
      t.integer :view_count, :default => 0
      t.datetime :last_viewed_at
    end
  end

  def self.down
    drop_table :brief_user_views
  end
end
