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

ActiveRecord::Schema.define(version: 2019_01_18_072905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.text "description"
    t.string "updated_by"
    t.text "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.date "finish_at"
    t.date "start_at"
    t.index ["person_id"], name: "index_activities_on_person_id"
  end

  create_table "advanced_trainings", id: :serial, force: :cascade do |t|
    t.text "description"
    t.string "updated_by"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "finish_at"
    t.date "start_at"
    t.index ["person_id"], name: "index_advanced_trainings_on_person_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "web"
    t.string "email"
    t.string "phone"
    t.string "partnermanager"
    t.string "contact_person"
    t.string "email_contact_person"
    t.string "phone_contact_person"
    t.string "offer_comment"
    t.string "crm"
    t.string "level"
    t.boolean "my_company", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "associations_updatet_at"
  end

  create_table "educations", id: :serial, force: :cascade do |t|
    t.text "location"
    t.text "title"
    t.datetime "updated_at"
    t.string "updated_by"
    t.integer "person_id"
    t.date "finish_at"
    t.date "start_at"
    t.index ["person_id"], name: "index_educations_on_person_id"
  end

  create_table "employee_quantities", force: :cascade do |t|
    t.string "category"
    t.integer "quantity"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employee_quantities_on_company_id"
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

  create_table "language_skills", force: :cascade do |t|
    t.string "language"
    t.string "level"
    t.string "certificate"
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_language_skills_on_person_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "location"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_locations_on_company_id"
  end

  create_table "offers", force: :cascade do |t|
    t.string "category"
    t.text "offer", default: [], array: true
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_offers_on_company_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.datetime "birthdate"
    t.string "location"
    t.string "updated_by"
    t.string "name"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.string "competences"
    t.bigint "company_id"
    t.datetime "associations_updatet_at"
    t.string "nationality"
    t.string "nationality2"
    t.integer "marital_status", default: 0, null: false
    t.string "email"
    t.string "department"
    t.index ["company_id"], name: "index_people_on_company_id"
  end

  create_table "people_roles", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "role_id"
    t.string "level"
    t.decimal "percent", precision: 5, scale: 2
    t.index ["person_id"], name: "index_people_roles_on_person_id"
    t.index ["role_id"], name: "index_people_roles_on_role_id"
  end

  create_table "person_competences", force: :cascade do |t|
    t.string "category"
    t.text "offer", default: [], array: true
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_person_competences_on_person_id"
  end

  create_table "project_technologies", force: :cascade do |t|
    t.text "offer", default: [], array: true
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_technologies_on_project_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "updated_by"
    t.text "description"
    t.text "title"
    t.text "role"
    t.text "technology"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.date "finish_at"
    t.date "start_at"
    t.index ["person_id"], name: "index_projects_on_person_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "ldap_uid"
    t.string "api_token"
    t.integer "failed_login_attempts", default: 0
    t.datetime "last_failed_login_attempt_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "employee_quantities", "companies"
  add_foreign_key "language_skills", "people"
  add_foreign_key "locations", "companies"
  add_foreign_key "offers", "companies"
  add_foreign_key "people", "companies"
  add_foreign_key "person_competences", "people"
  add_foreign_key "project_technologies", "projects"
end
