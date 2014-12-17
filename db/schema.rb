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

ActiveRecord::Schema.define(version: 20141217043830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fillings", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "price",              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "food_group"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "retired",            default: false
  end

  create_table "item_fillings", force: true do |t|
    t.integer  "item_id"
    t.integer  "filling_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_fillings", ["filling_id"], name: "index_item_fillings_on_filling_id", using: :btree
  add_index "item_fillings", ["item_id"], name: "index_item_fillings_on_item_id", using: :btree

  create_table "line_item_fillings", force: true do |t|
    t.integer  "line_item_id"
    t.integer  "filling_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
  end

  create_table "photos", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "property_id"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["property_id"], name: "index_photos_on_property_id", using: :btree

  create_table "properties", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "retired",            default: false
    t.integer  "occupancy"
    t.integer  "address_id"
    t.boolean  "bathroom_private",   default: true
    t.integer  "user_id"
    t.integer  "category_id"
  end

  add_index "properties", ["address_id"], name: "index_properties_on_address_id", using: :btree
  add_index "properties", ["category_id"], name: "index_properties_on_category_id", using: :btree
  add_index "properties", ["title"], name: "index_properties_on_title", unique: true, using: :btree
  add_index "properties", ["user_id"], name: "index_properties_on_user_id", using: :btree

  create_table "reservations", force: true do |t|
    t.string   "status",      default: "in_cart"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_id"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

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
  end

  add_index "users", ["address_id"], name: "index_users_on_address_id", using: :btree
  add_index "users", ["email_address"], name: "index_users_on_email_address", unique: true, using: :btree

end
