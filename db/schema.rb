# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090922170252) do

  create_table "assets", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  add_index "assets", ["attachable_id"], :name => "index_assets_on_attachable_id"

  create_table "brief_item_versions", :force => true do |t|
    t.integer  "brief_item_id"
    t.integer  "version"
    t.text     "title"
    t.text     "body"
    t.integer  "position"
    t.integer  "brief_id"
    t.integer  "template_question_id"
    t.datetime "revised_at"
  end

  add_index "brief_item_versions", ["brief_item_id"], :name => "index_brief_item_versions_on_brief_item_id"

  create_table "brief_items", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.integer  "position"
    t.integer  "brief_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_question_id"
    t.integer  "version"
  end

  create_table "brief_user_views", :force => true do |t|
    t.integer  "brief_id"
    t.integer  "user_id"
    t.integer  "view_count",     :default => 0
    t.datetime "last_viewed_at"
  end

  create_table "briefs", :force => true do |t|
    t.string  "title"
    t.integer "user_id"
    t.string  "state"
    t.integer "site_id"
    t.integer "template_brief_id"
    t.text    "most_important_message"
    t.boolean "delta"
  end

  add_index "briefs", ["delta"], :name => "index_briefs_on_delta"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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
    t.boolean  "existing_user",   :default => false
  end

  create_table "proposals", :force => true do |t|
    t.text     "short_description"
    t.text     "long_description"
    t.integer  "brief_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "title"
    t.string   "state"
  end

  create_table "questions", :force => true do |t|
    t.text     "body"
    t.text     "author_answer"
    t.integer  "brief_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brief_item_id"
  end

  create_table "sites", :force => true do |t|
    t.string "title"
  end

  create_table "template_brief_questions", :force => true do |t|
    t.integer "template_brief_id"
    t.integer "template_question_id"
  end

  create_table "template_briefs", :force => true do |t|
    t.string  "title"
    t.integer "site_id"
  end

  create_table "template_questions", :force => true do |t|
    t.text    "body"
    t.text    "help_message"
    t.boolean "optional"
    t.integer "template_section_id"
  end

  create_table "template_sections", :force => true do |t|
    t.text    "title"
    t.integer "position"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.integer  "invite_count"
    t.integer  "friends_count",       :default => 0, :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "watched_briefs", :force => true do |t|
    t.integer  "brief_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
