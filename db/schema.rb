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

ActiveRecord::Schema[7.1].define(version: 2026_05_21_223937) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", comment: "カテゴリー", force: :cascade do |t|
    t.bigint "group_id", null: false, comment: "所属共有グループID"
    t.string "name", null: false, comment: "カテゴリー名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "name"], name: "index_categories_on_group_id_and_name", unique: true
    t.index ["group_id"], name: "index_categories_on_group_id"
  end

  create_table "group_users", comment: "共有グループ所属情報", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "group_id", null: false, comment: "グループID"
    t.string "display_name", null: false, comment: "共有時の表示名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_users_on_group_id"
    t.index ["user_id", "group_id"], name: "index_group_users_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_users_on_user_id"
  end

  create_table "groups", comment: "共有グループ", force: :cascade do |t|
    t.string "invite_code", null: false, comment: "グループ招待コード"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invite_code"], name: "index_groups_on_invite_code", unique: true
  end

  create_table "items", comment: "在庫アイテム", force: :cascade do |t|
    t.bigint "group_id", null: false, comment: "所属共有グループID"
    t.bigint "category_id", null: false, comment: "カテゴリーID"
    t.string "name", null: false, comment: "商品名"
    t.integer "quantity", default: 0, null: false, comment: "在庫数"
    t.date "purchased_at", comment: "購入日"
    t.date "expired_at", comment: "期限日"
    t.text "memo", comment: "メモ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["group_id"], name: "index_items_on_group_id"
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

  add_foreign_key "categories", "groups"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "groups"
end
