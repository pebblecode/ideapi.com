class CreateWatchedBriefs < ActiveRecord::Migration
  def self.up
    create_table :watched_briefs do |t|
      t.integer :brief_id
      t.integer :creative_id

      t.timestamps
    end
  end

  def self.down
    drop_table :watched_briefs
  end
end
