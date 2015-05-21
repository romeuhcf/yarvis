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

ActiveRecord::Schema.define(version: 20150521174057) do

  create_table "build_jobs", force: true do |t|
    t.integer  "changeset_id"
    t.integer  "exit_status"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "build_spec"
    t.string   "container_id"
    t.string   "slug"
  end

  add_index "build_jobs", ["changeset_id"], name: "index_build_jobs_on_changeset_id", using: :btree

  create_table "changesets", force: true do |t|
    t.integer  "repository_id"
    t.string   "revision"
    t.string   "commit_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "changesets", ["repository_id"], name: "index_changesets_on_repository_id", using: :btree

  create_table "repositories", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_handled_revision"
    t.datetime "checked_at"
    t.boolean  "enabled"
    t.boolean  "active_check"
  end

end
