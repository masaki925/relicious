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

ActiveRecord::Schema.define(:version => 20120623095125) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.time     "avail_from"
    t.time     "avail_to"
    t.string   "option"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_avails", ["area_id"], :name => "index_user_avails_on_area_id"
  add_index "user_avails", ["user_id"], :name => "index_user_avails_on_user_id"

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
    t.string   "location"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

end
