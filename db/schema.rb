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

ActiveRecord::Schema.define(version: 2020_08_03_141359) do

  create_table "carts", force: :cascade do |t|
    t.string "name_of_store"
    t.integer "cart_number"
  end

  create_table "customeritems", force: :cascade do |t|
    t.integer "item_id"
    t.integer "customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "log_in_id"
    t.string "log_in_password"
    t.integer "cart_id"
    t.string "name"
    t.string "address"
    t.string "friend"
  end

  create_table "friends", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "cart_id"
    t.string "log_in_id"
    t.string "name"
  end

  create_table "items", force: :cascade do |t|
    t.string "item_type"
    t.float "price"
  end

end
