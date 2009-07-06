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

ActiveRecord::Schema.define(:version => 20090706173356) do

  create_table "brief_items", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.integer  "position"
    t.integer  "brief_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_question_id"
  end

  create_table "briefs", :force => true do |t|
    t.string  "title"
    t.integer "author_id"
    t.string  "state"
    t.integer "site_id"
    t.integer "template_brief_id"
    t.text    "most_important_message"
  end

  create_table "creative_proposals", :force => true do |t|
    t.text     "short_description"
    t.text     "long_description"
    t.integer  "brief_id"
    t.integer  "creative_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creative_questions", :force => true do |t|
    t.text     "body"
    t.text     "author_answer"
    t.integer  "creative_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brief_id"
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
    t.string   "type"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "watched_briefs", :force => true do |t|
    t.integer  "brief_id"
    t.integer  "creative_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
