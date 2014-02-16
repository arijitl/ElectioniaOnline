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

ActiveRecord::Schema.define(version: 20140216153934) do

  create_table "anticampaigns", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "candidate_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "bet"
    t.integer  "payoff"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "candidates", force: true do |t|
    t.string   "name"
    t.boolean  "young"
    t.boolean  "secular"
    t.boolean  "experienced"
    t.boolean  "clean"
    t.boolean  "eminent"
    t.boolean  "astute"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "description"
  end

  create_table "game_results", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.boolean  "votewin"
    t.integer  "income"
    t.integer  "expense"
    t.integer  "contribution"
    t.integer  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.date     "game_date"
    t.integer  "first_id"
    t.integer  "second_id"
    t.integer  "third_id"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "first_total"
    t.integer  "second_total"
    t.integer  "third_total"
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories"

  create_table "sponsors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.date     "game_date"
    t.string   "account"
    t.integer  "cost"
    t.integer  "return"
    t.integer  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
    t.integer  "bank"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "candidate_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "submitted"
  end

end
