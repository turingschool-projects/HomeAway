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

ActiveRecord::Schema.define(version: 20150523220058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country",    default: "USA"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "host_requests", force: true do |t|
    t.integer "user_id"
    t.string  "message"
  end

  add_index "host_requests", ["user_id"], name: "index_host_requests_on_user_id", using: :btree

  create_table "photos", force: true do |t|
    t.integer  "property_id"
    t.boolean  "primary",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "image_file_name"
  end

  add_index "photos", ["property_id"], name: "index_photos_on_property_id", using: :btree

  create_table "properties", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "price_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "retired",          default: false
    t.integer  "occupancy"
    t.integer  "address_id"
    t.boolean  "bathroom_private", default: true
    t.integer  "user_id"
    t.integer  "category_id"
  end

  add_index "properties", ["address_id"], name: "index_properties_on_address_id", using: :btree
  add_index "properties", ["category_id"], name: "index_properties_on_category_id", using: :btree
  add_index "properties", ["user_id"], name: "index_properties_on_user_id", using: :btree

  create_table "reservations", force: true do |t|
    t.string   "status",      default: "pending"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_id"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "user_connections", force: true do |t|
    t.integer  "host_id"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email_address"
    t.string   "display_name"
    t.string   "password_digest"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "host"
    t.integer  "address_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "accepts_cc"
    t.boolean  "accepts_cash"
    t.boolean  "accepts_check"
    t.string   "host_slug"
  end

  add_index "users", ["address_id"], name: "index_users_on_address_id", using: :btree
  add_index "users", ["email_address"], name: "index_users_on_email_address", unique: true, using: :btree

end
