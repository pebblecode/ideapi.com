class DropUnneededTables < ActiveRecord::Migration
  def self.up
    remove_index "invitations", ["redeemable_id", "redeemable_type"]
    remove_index "invitations", ["redeemable_id"]
    remove_index "invitations", ["redeemed_by_id"]
    remove_index "invitations", ["user_id"]
    
    drop_table :invitations
    
    remove_index "friendships", ["friend_id"]
    remove_index "friendships", ["user_id"]
    
    drop_table :friendships
  end

  def self.down
    create_table "friendships", :force => true do |t|
      t.integer  "user_id",     :null => false
      t.integer  "friend_id",   :null => false
      t.datetime "created_at"
      t.datetime "accepted_at"
    end
    
    create_table "invitations", :force => true do |t|
      t.string   "recipient_email"
      t.integer  "user_id"
      t.string   "code"
      t.datetime "redeemed_at"
      t.integer  "redeemed_by_id"
      t.string   "state"
      t.integer  "redeemable_id"
      t.string   "redeemable_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "invitations", ["redeemable_id", "redeemable_type"], :name => "index_invitations_on_redeemable_id_and_redeemable_type"
    add_index "invitations", ["redeemable_id"], :name => "index_invitations_on_redeemable_id"
    add_index "invitations", ["redeemed_by_id"], :name => "index_invitations_on_redeemed_by_id"
    add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"
    
    add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
    add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"
  end
end
