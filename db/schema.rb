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

ActiveRecord::Schema.define(version: 2019_01_06_054246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bots", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "currency_pair_id", null: false
    t.string "status", null: false
    t.datetime "start_at", null: false
    t.float "level_base"
    t.float "level_slope"
    t.integer "dca_interval_day"
    t.integer "dca_interval_hour"
    t.integer "dca_interval_minute"
    t.float "dca_settlment_amount"
    t.float "ts_key_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["currency_pair_id"], name: "index_bots_on_currency_pair_id"
    t.index ["type"], name: "index_bots_on_type"
    t.index ["user_id"], name: "index_bots_on_user_id"
  end

  create_table "currency_pairs", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "key_currency", limit: 64, null: false
    t.string "settlement_currency", limit: 64, null: false
  end

  create_table "order_logs", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.bigint "currency_pair_id", null: false
    t.string "job_id", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_order_logs_on_bot_id"
    t.index ["currency_pair_id"], name: "index_order_logs_on_currency_pair_id"
    t.index ["job_id"], name: "index_order_logs_on_job_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bots", "users"
  add_foreign_key "order_logs", "bots"
  add_foreign_key "order_logs", "currency_pairs"
end
