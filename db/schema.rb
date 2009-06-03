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

ActiveRecord::Schema.define(:version => 20090603134948) do

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
    t.integer "user_id"
    t.integer "brief_template_id"
  end

  create_table "creative_responses", :force => true do |t|
    t.text    "short_description"
    t.text    "long_description"
    t.integer "brief_id"
    t.integer "user_id"
  end

  create_table "response_types", :force => true do |t|
    t.string "title"
    t.string "input_type"
    t.string "options"
  end

  create_table "users", :force => true do |t|
    t.string "login"
    t.string "email"
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
  end

end
