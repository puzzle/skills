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

ActiveRecord::Schema.define(version: 20170404140341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.text     "description"
    t.string   "updated_by"
    t.text     "role"
    t.integer  "year_from"
    t.integer  "year_to"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "person_id"
    t.index ["person_id"], name: "index_activities_on_person_id", using: :btree
  end

  create_table "advanced_trainings", force: :cascade do |t|
    t.text     "description"
    t.string   "updated_by"
    t.integer  "year_from"
    t.integer  "year_to"
    t.integer  "person_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["person_id"], name: "index_advanced_trainings_on_person_id", using: :btree
  end

  create_table "educations", force: :cascade do |t|
    t.text     "location"
    t.text     "title"
    t.datetime "updated_at"
    t.string   "updated_by"
    t.integer  "year_from"
    t.integer  "year_to"
    t.integer  "person_id"
    t.index ["person_id"], name: "index_educations_on_person_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.datetime "birthdate"
    t.string   "language"
    t.string   "location"
    t.string   "martial_status"
    t.string   "updated_by"
    t.string   "name"
    t.string   "origin"
    t.string   "role"
    t.string   "title"
    t.integer  "status_id"
    t.integer  "origin_person_id"
    t.string   "variation_name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "type"
    t.string   "picture"
    t.string   "competences"
    t.index ["status_id"], name: "index_people_on_status_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "updated_by"
    t.text     "description"
    t.text     "title"
    t.text     "role"
    t.text     "technology"
    t.integer  "year_to"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "person_id"
    t.integer  "year_from"
    t.index ["person_id"], name: "index_projects_on_person_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "ldap_uid"
    t.string   "api_token"
    t.integer  "failed_login_attempts",        default: 0
    t.datetime "last_failed_login_attempt_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

end
