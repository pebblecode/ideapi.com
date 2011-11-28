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

ActiveRecord::Schema.define(:version => 20110120130717) do

  create_table "account_template_documents", :force => true do |t|
    t.integer "account_id"
    t.integer "template_document_id"
  end

  create_table "account_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "code"
    t.string   "state"
    t.datetime "redeemed_at"
    t.boolean  "document_creation",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                :default => false
    t.boolean  "can_create_documents", :default => false
  end

  add_index "account_users", ["account_id"], :name => "index_account_users_on_account_id"
  add_index "account_users", ["user_id"], :name => "index_account_users_on_user_id"

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_domain"
    t.datetime "deleted_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
  end

  add_index "accounts", ["full_domain"], :name => "index_accounts_on_full_domain"

  create_table "assets", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.text     "description"
  end

  add_index "assets", ["attachable_id", "attachable_type"], :name => "index_assets_on_attachable_id_and_attachable_type"
  add_index "assets", ["attachable_id"], :name => "index_assets_on_attachable_id"

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

  create_table "document_item_versions", :force => true do |t|
    t.integer  "document_item_id"
    t.integer  "version"
    t.text     "title"
    t.text     "body"
    t.integer  "position"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_question_id"
    t.datetime "revised_at"
    t.boolean  "is_heading",           :default => false
    t.text     "help_message"
    t.boolean  "optional"
  end

  add_index "document_item_versions", ["document_id"], :name => "index_document_item_versions_on_document_id"
  add_index "document_item_versions", ["document_item_id"], :name => "index_document_item_versions_on_document_item_id"
  add_index "document_item_versions", ["template_question_id"], :name => "index_document_item_versions_on_template_question_id"

  create_table "document_items", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.integer  "position"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_question_id"
    t.integer  "version"
    t.boolean  "is_heading",           :default => false
    t.text     "help_message"
    t.boolean  "optional"
  end

  add_index "document_items", ["document_id"], :name => "index_document_items_on_document_id"
  add_index "document_items", ["template_question_id"], :name => "index_document_items_on_template_question_id"

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.string   "state"
    t.integer  "site_id"
    t.integer  "template_document_id"
    t.text     "most_important_message"
    t.boolean  "delta"
    t.integer  "approver_id"
    t.integer  "author_id"
    t.integer  "account_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "documents", ["approver_id"], :name => "index_documents_on_approver_id"
  add_index "documents", ["delta"], :name => "index_documents_on_delta"
  add_index "documents", ["site_id"], :name => "index_documents_on_site_id"
  add_index "documents", ["template_document_id"], :name => "index_documents_on_template_document_id"

  create_table "password_resets", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "remote_ip"
    t.string   "token"
    t.datetime "created_at"
  end

  create_table "proposals", :force => true do |t|
    t.text     "short_description"
    t.text     "long_description"
    t.integer  "document_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "title"
    t.string   "state"
  end

  add_index "proposals", ["document_id"], :name => "index_proposals_on_document_id"
  add_index "proposals", ["user_id"], :name => "index_proposals_on_user_id"

  create_table "questions", :force => true do |t|
    t.text     "body"
    t.text     "author_answer"
    t.integer  "document_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_item_id"
    t.integer  "answered_by_id"
  end

  add_index "questions", ["document_id"], :name => "index_questions_on_document_id"
  add_index "questions", ["document_item_id"], :name => "index_questions_on_document_item_id"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "sites", :force => true do |t|
    t.string "title"
  end

  create_table "subscription_affiliates", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",       :precision => 6, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "subscription_affiliates", ["token"], :name => "index_subscription_affiliates_on_token"

  create_table "subscription_discounts", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "amount",                 :precision => 6, :scale => 2, :default => 0.0
    t.boolean  "percent"
    t.date     "start_on"
    t.date     "end_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "apply_to_setup",                                       :default => true
    t.boolean  "apply_to_recurring",                                   :default => true
    t.integer  "trial_period_extension",                               :default => 0
  end

  create_table "subscription_payments", :force => true do |t|
    t.integer  "account_id"
    t.integer  "subscription_id"
    t.decimal  "amount",                    :precision => 10, :scale => 2, :default => 0.0
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "setup"
    t.boolean  "misc"
    t.integer  "subscription_affiliate_id"
    t.decimal  "affiliate_amount",          :precision => 6,  :scale => 2, :default => 0.0
  end

  add_index "subscription_payments", ["account_id"], :name => "index_subscription_payments_on_account_id"
  add_index "subscription_payments", ["subscription_id"], :name => "index_subscription_payments_on_subscription_id"

  create_table "subscription_plans", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",         :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_limit"
    t.integer  "renewal_period",                                :default => 1
    t.decimal  "setup_amount",   :precision => 10, :scale => 2
    t.integer  "trial_period",                                  :default => 1
    t.integer  "document_limit"
  end

  create_table "subscriptions", :force => true do |t|
    t.decimal  "amount",                    :precision => 10, :scale => 2
    t.datetime "next_renewal_at"
    t.string   "card_number"
    t.string   "card_expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                                    :default => "trial"
    t.integer  "subscription_plan_id"
    t.integer  "account_id"
    t.integer  "user_limit"
    t.integer  "renewal_period",                                           :default => 1
    t.string   "billing_id"
    t.integer  "subscription_discount_id"
    t.integer  "subscription_affiliate_id"
    t.integer  "document_limit"
  end

  add_index "subscriptions", ["account_id"], :name => "index_subscriptions_on_account_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "template_document_questions", :force => true do |t|
    t.integer "template_document_id"
    t.integer "template_question_id"
    t.integer "position"
  end

  add_index "template_document_questions", ["template_document_id"], :name => "index_template_document_questions_on_template_document_id"
  add_index "template_document_questions", ["template_question_id"], :name => "index_template_document_questions_on_template_question_id"

  create_table "template_documents", :force => true do |t|
    t.string  "title"
    t.integer "site_id"
    t.boolean "default", :default => false
  end

  add_index "template_documents", ["site_id"], :name => "index_template_documents_on_site_id"

  create_table "template_questions", :force => true do |t|
    t.text    "body"
    t.text    "help_message"
    t.boolean "optional"
    t.integer "template_section_id"
    t.boolean "is_heading",          :default => false
    t.text    "default_content"
  end

  add_index "template_questions", ["template_section_id"], :name => "index_template_questions_on_template_section_id"

  create_table "template_sections", :force => true do |t|
    t.text    "title"
    t.integer "position"
  end

  create_table "timeline_events", :force => true do |t|
    t.string   "event_type"
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "log_level",              :default => 1
  end

  add_index "timeline_events", ["actor_id", "actor_type"], :name => "index_timeline_events_on_actor_id_and_actor_type"
  add_index "timeline_events", ["secondary_subject_id", "secondary_subject_type"], :name => "index_timeline_events_ssubs"
  add_index "timeline_events", ["subject_id", "subject_type"], :name => "index_timeline_events_on_subject_id_and_subject_type"

  create_table "user_documents", :force => true do |t|
    t.integer  "document_id"
    t.integer  "user_id"
    t.boolean  "author",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count",       :default => 0
    t.datetime "last_viewed_at"
    t.integer  "added_by_user_id"
  end

  add_index "user_documents", ["document_id"], :name => "index_user_documents_on_document_id"
  add_index "user_documents", ["user_id"], :name => "index_user_documents_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "screename"
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
    t.integer  "friends_count",       :default => 0,  :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "state"
    t.string   "invite_code"
    t.string   "job_title"
    t.string   "telephone"
    t.string   "telephone_ext"
    t.datetime "current_login_at"
    t.integer  "invited_by_id"
    t.string   "perishable_token",    :default => "", :null => false
    t.text     "user_agent_string"
  end

  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

  create_table "users_bak", :id => false, :force => true do |t|
    t.integer  "id",                  :default => 0,  :null => false
    t.string   "screename"
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
    t.integer  "friends_count",       :default => 0,  :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "state"
    t.string   "invite_code"
    t.string   "job_title"
    t.string   "telephone"
    t.string   "telephone_ext"
    t.datetime "current_login_at"
    t.integer  "invited_by_id"
    t.string   "perishable_token",    :default => "", :null => false
    t.text     "user_agent_string"
  end

  create_table "vw_account_owners", :id => false, :force => true do |t|
    t.string   "email"
    t.integer  "id",          :default => 0, :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_domain"
    t.datetime "deleted_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "watched_documents", :force => true do |t|
    t.integer  "document_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watched_documents", ["document_id"], :name => "index_watched_documents_on_document_id"
  add_index "watched_documents", ["user_id"], :name => "index_watched_documents_on_user_id"

end
