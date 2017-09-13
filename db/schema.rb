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

ActiveRecord::Schema.define(version: 20170913112831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "action"
    t.integer  "user_id"
    t.string   "user_email"
    t.integer  "activity_object_id"
    t.string   "object_text"
    t.string   "object_url"
    t.integer  "secondary_object_id"
    t.string   "secondary_object_url"
    t.string   "secondary_object_class"
    t.string   "secondary_object_method"
    t.string   "secondary_object_text"
    t.string   "type"
    t.integer  "library_id"
    t.integer  "account_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "ip"
    t.string   "browser"
    t.integer  "session_ip_id"
    t.datetime "deleted_at"
    t.string   "location"
  end

  create_table "asset_infos", force: :cascade do |t|
    t.integer  "asset_id"
    t.integer  "info_field_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["asset_id", "info_field_id"], name: "asset_id_info_field_id", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_asset_infos_on_deleted_at", using: :btree
  end

  create_table "assets", force: :cascade do |t|
    t.string   "filename"
    t.bigint   "filesize"
    t.string   "file_id"
    t.integer  "file_type",                 default: 0
    t.integer  "library_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uploader_id"
    t.integer  "account_id"
    t.integer  "comments_count",            default: 0
    t.json     "media_info",                default: {}, null: false
    t.json     "exif_data",                 default: {}, null: false
    t.string   "thumbnail_file_id"
    t.datetime "soft_deleted_at"
    t.string   "mime_type"
    t.string   "s3_name"
    t.string   "s3_url"
    t.string   "s3_region"
    t.string   "s3_thumbnail_path"
    t.string   "checksum"
    t.string   "legacy_id"
    t.string   "legacy_filehash"
    t.string   "legacy_thumbnail_filehash"
    t.string   "title"
    t.index ["account_id"], name: "index_assets_on_account_id", using: :btree
    t.index ["library_id"], name: "index_assets_on_library_id", using: :btree
    t.index ["soft_deleted_at"], name: "index_assets_on_soft_deleted_at", using: :btree
    t.index ["uploader_id"], name: "index_assets_on_uploader_id", using: :btree
  end

  create_table "avatars", force: :cascade do |t|
    t.string   "s3_name"
    t.string   "s3_thumbnail_path"
    t.integer  "user_id"
    t.integer  "crop_x"
    t.integer  "crop_y"
    t.integer  "crop_width"
    t.integer  "crop_height"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "brandings", force: :cascade do |t|
    t.string   "file_id"
    t.string   "colour",            default: "#ffffff"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_file_id"
    t.string   "s3_name"
    t.string   "s3_thumbnail_path"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "asset_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["asset_id"], name: "index_comments_on_asset_id", using: :btree
    t.index ["author_id"], name: "index_comments_on_author_id", using: :btree
  end

  create_table "info_fields", force: :cascade do |t|
    t.integer  "field_type", default: 0
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "key"
    t.datetime "deleted_at"
    t.boolean  "required",   default: false
    t.boolean  "system",     default: false
    t.index ["deleted_at"], name: "index_info_fields_on_deleted_at", using: :btree
  end

  create_table "libraries", force: :cascade do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "assets_count", default: 0
    t.integer  "creator_id"
    t.time     "deleted_at"
    t.string   "legacy_id"
    t.index ["account_id"], name: "index_libraries_on_account_id", using: :btree
  end

  create_table "thumbnails", force: :cascade do |t|
    t.string   "name"
    t.string   "s3_name"
    t.integer  "asset_id"
    t.string   "dimensions"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint   "filesize"
  end

  create_table "transcodes", force: :cascade do |t|
    t.integer  "asset_id"
    t.string   "name"
    t.string   "file_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "s3_name"
    t.string   "s3_region"
    t.string   "legacy_filehash"
    t.datetime "deleted_at"
    t.bigint   "filesize"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "chillibean_staff"
    t.boolean  "activated",              default: false
    t.string   "token"
    t.string   "avatar_file_id"
    t.string   "company"
    t.string   "job_title"
    t.string   "phone"
    t.string   "timezone"
    t.string   "cropped_avatar_file_id"
    t.boolean  "suspended",              default: false
    t.boolean  "force_password_change",  default: false
    t.date     "activation_date"
    t.date     "password_reset_date"
    t.string   "last_password_digest"
    t.string   "legacy_id"
    t.datetime "deleted_at"
  end

end
