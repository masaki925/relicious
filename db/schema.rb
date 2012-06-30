# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120626223657) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "languages", ["code"], :name => "index_languages_on_code"

  create_table "meetup_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meetup_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "meetup_comments", ["meetup_id"], :name => "index_meetup_comments_on_meetup_id"
  add_index "meetup_comments", ["user_id"], :name => "index_meetup_comments_on_user_id"

  create_table "meetups", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "area_id"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.boolean  "public"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "meetups", ["user_id"], :name => "index_meetups_on_user_id"

  create_table "user_avails", :force => true do |t|
    t.integer  "user_id"
    t.integer  "area_id"
    t.string   "day"
    t.time     "avail_from"
    t.time     "avail_to"
    t.string   "avail_option"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "user_avails", ["area_id"], :name => "index_user_avails_on_area_id"
  add_index "user_avails", ["user_id"], :name => "index_user_avails_on_user_id"

  create_table "user_languages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_languages", ["language_id"], :name => "index_user_languages_on_language_id"
  add_index "user_languages", ["user_id"], :name => "index_user_languages_on_user_id"

  create_table "user_meetup_permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meetup_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_meetup_permissions", ["meetup_id"], :name => "index_user_meetup_permissions_on_meetup_id"
  add_index "user_meetup_permissions", ["user_id"], :name => "index_user_meetup_permissions_on_user_id"

  create_table "user_reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meetup_id"
    t.integer  "reviewed_user_id"
    t.boolean  "recommend"
    t.text     "about_user"
    t.text     "about_experience"
    t.integer  "eval_personal"
    t.integer  "eval_language"
    t.integer  "eval_gourmet"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "user_reviews", ["meetup_id"], :name => "index_user_reviews_on_meetup_id"
  add_index "user_reviews", ["reviewed_user_id"], :name => "index_user_reviews_on_reviewed_user_id"
  add_index "user_reviews", ["user_id"], :name => "index_user_reviews_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                      :null => false
    t.string   "screen_name"
    t.string   "email"
    t.string   "provider",                  :null => false
    t.integer  "provider_uid", :limit => 8, :null => false
    t.string   "auth_token",                :null => false
    t.date     "birthday"
    t.text     "introduction"
    t.string   "education"
    t.string   "work"
    t.string   "gender"
    t.string   "locale"
    t.string   "location"
    t.text     "likes"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

end
