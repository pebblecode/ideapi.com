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

ActiveRecord::Schema.define(:version => 20090608145654) do

  create_table "brief_answers", :force => true do |t|
    t.text    "body"
    t.integer "brief_question_id"
    t.integer "brief_id"
    t.integer "brief_section_id"
  end

  create_table "brief_configs", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brief_questions", :force => true do |t|
    t.string  "title"
    t.text    "help_text"
    t.integer "response_type_id"
    t.boolean "optional",         :default => false
  end

  create_table "brief_section_brief_questions", :force => true do |t|
    t.integer  "brief_section_id"
    t.integer  "brief_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "brief_section_brief_templates", :force => true do |t|
    t.integer "brief_section_id"
    t.integer "brief_template_id"
  end

  create_table "brief_sections", :force => true do |t|
    t.string  "title"
    t.text    "strapline"
    t.integer "position"
    t.integer "brief_config_id"
  end

  create_table "brief_templates", :force => true do |t|
    t.string   "title"
    t.integer  "brief_config_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "briefs", :force => true do |t|
    t.string  "title"
    t.integer "author_id"
    t.integer "brief_template_id"
    t.string  "state"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment",                        :default => ""
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "creative_proposals", :force => true do |t|
    t.string   "short_description"
    t.text     "long_description"
    t.integer  "brief_id"
    t.integer  "creative_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creative_questions", :force => true do |t|
    t.text     "body"
    t.text     "answer"
    t.integer  "creative_id"
    t.integer  "brief_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "response_types", :force => true do |t|
    t.string "title"
    t.string "input_type"
    t.string "options"
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

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "uniq_one_vote_only", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

end
