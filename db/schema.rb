# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_27_014759) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.text "description"
    t.integer "lock_version"
    t.string "name"
    t.integer "parent_id"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.integer "updated_by_id"
    t.string "uuid"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "groups_permissions", id: false, force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "permission_id", null: false
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_permissions_on_slug", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.text "description"
    t.integer "lock_version"
    t.string "name"
    t.decimal "price"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.integer "updated_by_id"
    t.string "uuid"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.datetime "deleted_at"
    t.integer "deleted_by_id"
    t.string "email_address", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "lock_version"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.integer "updated_by_id"
    t.string "uuid"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
