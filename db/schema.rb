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

ActiveRecord::Schema.define(version: 20160805150537) do

  create_table "dataset_assignments", force: :cascade do |t|
    t.integer  "taskflow_id"
    t.integer  "dataset_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "dataset_assignments", ["taskflow_id", "dataset_id"], name: "index_dataset_assignments_on_taskflow_id_and_dataset_id"

  create_table "datasets", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "media", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "dataset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

end
