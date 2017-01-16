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

ActiveRecord::Schema.define(version: 20160921161328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dataset_assignments", force: :cascade do |t|
    t.integer  "taskflow_id"
    t.integer  "dataset_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "dataset_assignments", ["taskflow_id", "dataset_id"], name: "index_dataset_assignments_on_taskflow_id_and_dataset_id", using: :btree

  create_table "datasets", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "media", force: :cascade do |t|
    t.integer  "aam_id"
    t.string   "mime_type"
    t.string   "file"
    t.string   "accession_number"
    t.string   "caption"
    t.string   "caption_alt"
    t.string   "identifier"
    t.string   "place"
    t.string   "place_id"
    t.string   "object_id"
    t.string   "actor_appellation"
    t.string   "collection"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "media_type_id"
    t.string   "object_note"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "description"
    t.string   "image"
    t.string   "avatar"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "responses", force: :cascade do |t|
    t.string   "session_id"
    t.string   "image_id"
    t.string   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_responses", force: :cascade do |t|
    t.string   "session_id"
    t.string   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "name"
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "category"
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["parent_id"], name: "index_tags_on_parent_id", using: :btree

  create_table "taskflows", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "project_id"
    t.integer  "first_task_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.integer  "task_type"
    t.text     "help"
    t.text     "data"
    t.integer  "taskflow_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.boolean  "guest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
