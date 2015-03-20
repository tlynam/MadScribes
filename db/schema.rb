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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150320002823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sentences", force: :cascade do |t|
    t.text     "body",                       null: false
    t.integer  "user_id",                    null: false
    t.integer  "story_id",                   null: false
    t.integer  "round",      default: 1,     null: false
    t.integer  "votes",      default: [],    null: false, array: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "winner",     default: false, null: false
  end

  add_index "sentences", ["story_id"], name: "index_sentences_on_story_id", using: :btree
  add_index "sentences", ["user_id"], name: "index_sentences_on_user_id", using: :btree
  add_index "sentences", ["votes"], name: "index_sentences_on_votes", using: :btree

  create_table "stories", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.integer  "writing_period", default: 45, null: false
    t.integer  "voting_period",  default: 45, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "started_at"
    t.integer  "rounds",         default: 10, null: false
  end

  add_index "stories", ["user_id"], name: "index_stories_on_user_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "story_id"
  end

  add_index "subscriptions", ["story_id"], name: "index_subscriptions_on_story_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "sentences", "stories"
  add_foreign_key "sentences", "users"
end
