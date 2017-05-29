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

ActiveRecord::Schema.define(version: 20170523091825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "description", limit: 5000
    t.datetime "updated_at", null: false
    t.string "updated_by", limit: 255
    t.string "role", limit: 500
    t.integer "year_from"
    t.integer "year_to"
    t.integer "person_id", null: false
    t.datetime "created_at"
  end

  create_table "advanced_trainings", id: :serial, force: :cascade do |t|
    t.string "description", limit: 5000
    t.datetime "updated_at", null: false
    t.string "updated_by", limit: 255
    t.integer "year_from"
    t.integer "year_to"
    t.integer "person_id", null: false
    t.datetime "created_at"
  end

  create_table "competences", id: :serial, force: :cascade do |t|
    t.text "description"
    t.datetime "updated_at"
    t.string "updated_by"
    t.integer "person_id"
    t.index ["person_id"], name: "index_competences_on_person_id"
  end

  create_table "educations", id: :serial, force: :cascade do |t|
    t.string "location", limit: 500
    t.string "title", limit: 500
    t.datetime "updated_at", null: false
    t.string "updated_by", limit: 255
    t.integer "year_from"
    t.integer "year_to"
    t.integer "person_id", null: false
    t.datetime "created_at"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.datetime "birthdate"
    t.string "language", limit: 100
    t.string "location", limit: 100
    t.string "martial_status", limit: 100
    t.datetime "updated_at", null: false
    t.string "updated_by", limit: 255
    t.string "name", limit: 100
    t.string "origin", limit: 100
    t.string "role", limit: 100
    t.string "title", limit: 100
    t.integer "status_id", default: 1, null: false
    t.integer "origin_person_id", default: -1
    t.string "variation_name", limit: 100, default: "aktuelles CV"
    t.datetime "created_at"
    t.string "type"
    t.string "picture"
    t.string "competences"
    t.index ["name", "birthdate", "variation_name"], name: "uk_bricss82wi8axdqf9hvmwn2e2", unique: true
    t.index ["name", "birthdate", "variation_name"], name: "uk_name_birtdate_variation", unique: true
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.datetime "updated_at", null: false
    t.string "updated_by", limit: 255
    t.string "description", limit: 5000
    t.string "title", limit: 500
    t.string "role", limit: 5000
    t.string "technology", limit: 5000
    t.integer "year_from"
    t.integer "year_to"
    t.integer "person_id", default: 1, null: false
    t.datetime "created_at"
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.string "status"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "ldap_uid"
    t.string "api_token"
    t.integer "failed_login_attempts", default: 0
    t.datetime "last_failed_login_attempt_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "activities", "people", name: "fk_h60x6cdgg0viu1yqxmksjqhrd"
  add_foreign_key "advanced_trainings", "people", name: "fk_9d1no9ju30dtstakwm89jwtev"
  add_foreign_key "educations", "people", name: "fk_qr8q3lcwnth3jlf68cr8unohs"
  add_foreign_key "projects", "people", name: "fk_person_project"
end
