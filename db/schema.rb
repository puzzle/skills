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

ActiveRecord::Schema.define(version: 20161003130519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :integer, force: :cascade do |t|
    t.string   "description", limit: 5000, null: false
    t.datetime "updated_at",               null: false
    t.string   "updated_by",  limit: 255,  null: false
    t.string   "role",        limit: 500,  null: false
    t.integer  "year_from",                null: false
    t.integer  "year_to",                  null: false
    t.integer  "person_id",                null: false
    t.datetime "created_at"
  end

  create_table "advanced_trainings", id: :integer, force: :cascade do |t|
    t.string   "description", limit: 5000, null: false
    t.datetime "updated_at",               null: false
    t.string   "updated_by",  limit: 255,  null: false
    t.integer  "year_from",                null: false
    t.integer  "year_to",                  null: false
    t.integer  "person_id",                null: false
    t.datetime "created_at"
  end

  create_table "competences", id: :integer, force: :cascade do |t|
    t.string   "description", limit: 5000,             null: false
    t.datetime "updated_at",                           null: false
    t.string   "updated_by",  limit: 255,              null: false
    t.integer  "person_id",                default: 1, null: false
    t.datetime "created_at"
    t.index ["person_id"], name: "uk_d8au84bmlr3io7bk9c2hu0puq", unique: true, using: :btree
  end

  create_table "educations", id: :integer, force: :cascade do |t|
    t.string   "location",   limit: 500, null: false
    t.string   "type",       limit: 500, null: false
    t.datetime "updated_at",             null: false
    t.string   "updated_by", limit: 255, null: false
    t.integer  "year_from",              null: false
    t.integer  "year_to",                null: false
    t.integer  "person_id",              null: false
    t.datetime "created_at"
  end

  create_table "expertise_category", id: :integer, force: :cascade do |t|
    t.string "expertise_discipline", limit: 255, null: false
    t.string "name",                 limit: 255, null: false
  end

  create_table "expertise_topic", id: :integer, force: :cascade do |t|
    t.string  "name",                 limit: 255, null: false
    t.boolean "user_topic",                       null: false
    t.integer "fk_expertisecategory",             null: false
  end

  create_table "expertise_topic_skill_values", id: :integer, force: :cascade do |t|
    t.string  "description",         limit: 255, null: false
    t.integer "number_of_projects",              null: false
    t.string  "skill_level",         limit: 255, null: false
    t.integer "year_of_last_use",                null: false
    t.integer "years_of_experience",             null: false
    t.integer "fk_expertise_topic",              null: false
    t.integer "fk_person",                       null: false
  end

  create_table "people", id: :integer, force: :cascade do |t|
    t.datetime "birthdate",                                                          null: false
    t.integer  "profile_picture"
    t.string   "language",        limit: 100,                                        null: false
    t.string   "location",        limit: 100,                                        null: false
    t.string   "martial_status",  limit: 100,                                        null: false
    t.datetime "updated_at",                                                         null: false
    t.string   "updated_by",      limit: 255,                                        null: false
    t.string   "name",            limit: 100,                                        null: false
    t.string   "origin",          limit: 100,                                        null: false
    t.string   "role",            limit: 100,                                        null: false
    t.string   "title",           limit: 100,                                        null: false
    t.integer  "status_id",                   default: 1,                            null: false
    t.integer  "variation_id",                default: -1,                           null: false
    t.string   "variation_name",  limit: 100, default: "aktuelles CV",               null: false
    t.datetime "variation_date",              default: -> { "('now'::text)::date" }, null: false
    t.datetime "created_at"
    t.index ["name", "birthdate", "variation_name"], name: "uk_bricss82wi8axdqf9hvmwn2e2", unique: true, using: :btree
    t.index ["name", "birthdate", "variation_name"], name: "uk_name_birtdate_variation", unique: true, using: :btree
  end

  create_table "projects", id: :integer, force: :cascade do |t|
    t.datetime "updated_at",                           null: false
    t.string   "updated_by",  limit: 255,              null: false
    t.string   "description", limit: 5000,             null: false
    t.string   "title",       limit: 500,              null: false
    t.string   "role",        limit: 5000,             null: false
    t.string   "technology",  limit: 5000,             null: false
    t.integer  "yearfrom",                             null: false
    t.integer  "year_to",                              null: false
    t.integer  "person_id",                default: 1, null: false
    t.datetime "created_at"
  end

  create_table "statuses", id: :integer, force: :cascade do |t|
    t.string "status", limit: 100, null: false
  end

  add_foreign_key "activities", "people", name: "fk_h60x6cdgg0viu1yqxmksjqhrd"
  add_foreign_key "advanced_trainings", "people", name: "fk_9d1no9ju30dtstakwm89jwtev"
  add_foreign_key "competences", "people", name: "fk_person_competence"
  add_foreign_key "educations", "people", name: "fk_qr8q3lcwnth3jlf68cr8unohs"
  add_foreign_key "expertise_topic", "expertise_category", column: "fk_expertisecategory", name: "fk_sgn8rfc9d3cmay8ifiwuftd0s"
  add_foreign_key "expertise_topic_skill_values", "expertise_topic", column: "fk_expertise_topic", name: "fk_43p7gm1x9blbpeccvrcv3xdt8"
  add_foreign_key "expertise_topic_skill_values", "people", column: "fk_person", name: "fk_f8q96ahd85871dq3396xboprs"
  add_foreign_key "people", "statuses", name: "fk_fvgor3lwaybcryho1rkecma08"
  add_foreign_key "projects", "people", name: "fk_person_project"
end
