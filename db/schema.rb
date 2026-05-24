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

ActiveRecord::Schema[7.1].define(version: 2026_05_24_012224) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", comment: "カテゴリー", force: :cascade do |t|
    t.bigint "group_id", null: false, comment: "所属共有グループID"
    t.string "name", null: false, comment: "カテゴリー名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "name"], name: "index_categories_on_group_id_and_name", unique: true
    t.index ["group_id"], name: "index_categories_on_group_id"
  end

  create_table "consumptions", comment: "消費履歴", force: :cascade do |t|
    t.bigint "group_id", null: false, comment: "所属共有グループID"
    t.bigint "category_id", comment: "カテゴリーID"
    t.string "name", null: false, comment: "消費した商品名"
    t.date "consumed_on", null: false, comment: "消費日"
    t.text "memo", comment: "消費時点のメモ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category_name", null: false, comment: "消費時点のカテゴリー名"
    t.index ["category_id"], name: "index_consumptions_on_category_id"
    t.index ["group_id"], name: "index_consumptions_on_group_id"
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

  create_table "inquiries", comment: "お問い合わせ", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "問い合わせユーザーID"
    t.integer "inquiry_type", null: false, comment: "問い合わせ種類"
    t.string "email", null: false, comment: "返信先メールアドレス"
    t.text "content", null: false, comment: "問い合わせ内容"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inquiries_on_user_id"
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

  create_table "shopping_items", comment: "買い物アイテム", force: :cascade do |t|
    t.bigint "shopping_list_id", null: false, comment: "所属買い物リストID"
    t.bigint "category_id", null: false, comment: "カテゴリーID"
    t.string "name", null: false, comment: "商品名"
    t.integer "quantity", default: 1, null: false, comment: "購入予定数"
    t.text "memo", comment: "メモ"
    t.boolean "is_purchased", default: false, null: false, comment: "購入済みフラグ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_shopping_items_on_category_id"
    t.index ["shopping_list_id"], name: "index_shopping_items_on_shopping_list_id"
  end

  create_table "shopping_lists", comment: "買い物リスト", force: :cascade do |t|
    t.bigint "group_id", null: false, comment: "所属共有グループID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_shopping_lists_on_group_id", unique: true
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "groups"
  add_foreign_key "consumptions", "categories"
  add_foreign_key "consumptions", "groups"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "inquiries", "users"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "groups"
  add_foreign_key "shopping_items", "categories"
  add_foreign_key "shopping_items", "shopping_lists"
  add_foreign_key "shopping_lists", "groups"
end
