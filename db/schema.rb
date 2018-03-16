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

ActiveRecord::Schema.define(version: 20180316104707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.text "description"
    t.string "updated_by"
    t.text "role"
    t.integer "year_from"
    t.integer "year_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_activities_on_person_id"
  end

  create_table "advanced_trainings", id: :serial, force: :cascade do |t|
    t.text "description"
    t.string "updated_by"
    t.integer "year_from"
    t.integer "year_to"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_advanced_trainings_on_person_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "web"
    t.string "email"
    t.string "phone"
    t.string "partnermanager"
    t.string "contact_person"
    t.string "email_contact_person"
    t.string "phone_contact_person"
    t.string "crm"
    t.string "level"
    t.integer "number_MA_total"
    t.integer "number_MA_dev"
    t.integer "number_MA_sys_mid"
    t.integer "number_MA_PL"
    t.integer "number_MA_UX"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educations", id: :serial, force: :cascade do |t|
    t.text "location"
    t.text "title"
    t.datetime "updated_at"
    t.string "updated_by"
    t.integer "year_from"
    t.integer "year_to"
    t.integer "person_id"
    t.index ["person_id"], name: "index_educations_on_person_id"
  end

  create_table "expertise_categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "discipline", null: false
  end

  create_table "expertise_topic_skill_values", force: :cascade do |t|
    t.integer "years_of_experience"
    t.integer "number_of_projects"
    t.integer "last_use"
    t.integer "skill_level"
    t.string "comment"
    t.bigint "person_id", null: false
    t.bigint "expertise_topic_id", null: false
    t.index ["expertise_topic_id"], name: "index_expertise_topic_skill_values_on_expertise_topic_id"
    t.index ["person_id"], name: "index_expertise_topic_skill_values_on_person_id"
  end

  create_table "expertise_topics", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "user_topic", default: false
    t.bigint "expertise_category_id", null: false
    t.index ["expertise_category_id"], name: "index_expertise_topics_on_expertise_category_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.datetime "birthdate"
    t.string "language"
    t.string "location"
    t.string "martial_status"
    t.string "updated_by"
    t.string "name"
    t.string "origin"
    t.string "role"
    t.string "title"
    t.integer "status_id"
    t.integer "origin_person_id"
    t.string "variation_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "picture"
    t.string "competences"
    t.string "company"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_people_on_company_id"
    t.index ["status_id"], name: "index_people_on_status_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "updated_by"
    t.text "description"
    t.text "title"
    t.text "role"
    t.text "technology"
    t.integer "year_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.integer "year_from"
    t.index ["person_id"], name: "index_projects_on_person_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "ldap_uid"
    t.string "api_token"
    t.integer "failed_login_attempts", default: 0
    t.datetime "last_failed_login_attempt_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "people", "companies"
end
