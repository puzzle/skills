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

ActiveRecord::Schema[8.1].define(version: 2025_07_24_072939) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.boolean "display_in_cv", default: true, null: false
    t.integer "month_from"
    t.integer "month_to"
    t.integer "person_id"
    t.text "role"
    t.datetime "updated_at", precision: nil, null: false
    t.string "updated_by"
    t.integer "year_from", null: false
    t.integer "year_to"
    t.index ["person_id"], name: "index_activities_on_person_id"
  end

  create_table "advanced_trainings", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.boolean "display_in_cv", default: true, null: false
    t.integer "month_from"
    t.integer "month_to"
    t.integer "person_id"
    t.datetime "updated_at", precision: nil, null: false
    t.string "updated_by"
    t.integer "year_from", null: false
    t.integer "year_to"
    t.index ["person_id"], name: "index_advanced_trainings_on_person_id"
  end

  create_table "auth_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "is_admin", default: false, null: false
    t.boolean "is_conf_admin", default: false, null: false
    t.datetime "last_login"
    t.string "name"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_auth_users_on_uid", unique: true
  end

  create_table "branch_adresses", force: :cascade do |t|
    t.string "adress_information"
    t.string "country"
    t.datetime "created_at", null: false
    t.boolean "default_branch_adress"
    t.string "short_name"
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "parent_id"
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.text "comment"
    t.integer "course_duration"
    t.datetime "created_at", null: false
    t.string "designation"
    t.integer "exam_duration"
    t.decimal "points_value", null: false
    t.string "provider"
    t.integer "study_time"
    t.string "title", null: false
    t.string "type_of_exam"
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.boolean "reminder_mails_active", default: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "contributions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "display_in_cv", default: true, null: false
    t.integer "month_from"
    t.integer "month_to"
    t.integer "person_id"
    t.string "reference"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "year_from"
    t.integer "year_to"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at"
    t.string "cron"
    t.datetime "failed_at"
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at"
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "department_skill_snapshots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "department_id", null: false
    t.text "department_skill_levels"
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_skill_snapshots_on_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_departments_on_discarded_at"
  end

  create_table "educations", id: :serial, force: :cascade do |t|
    t.boolean "display_in_cv", default: true, null: false
    t.text "location"
    t.integer "month_from"
    t.integer "month_to"
    t.integer "person_id"
    t.text "title"
    t.datetime "updated_at", precision: nil
    t.string "updated_by"
    t.integer "year_from", null: false
    t.integer "year_to"
    t.index ["person_id"], name: "index_educations_on_person_id"
  end

  create_table "language_skills", force: :cascade do |t|
    t.string "certificate"
    t.datetime "created_at", precision: nil, null: false
    t.string "language"
    t.string "level"
    t.bigint "person_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["person_id"], name: "index_language_skills_on_person_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.datetime "associations_updated_at", precision: nil
    t.datetime "birthdate", precision: nil
    t.bigint "company_id"
    t.string "competence_notes"
    t.datetime "created_at", precision: nil, null: false
    t.integer "department_id"
    t.boolean "display_competence_notes_in_cv", default: true, null: false
    t.string "email"
    t.string "location"
    t.integer "marital_status", default: 0
    t.string "name"
    t.string "nationality"
    t.string "nationality2"
    t.string "picture"
    t.string "ptime_data_provider"
    t.integer "ptime_employee_id"
    t.boolean "reminder_mails_active", default: true
    t.string "shortname"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.string "updated_by"
    t.index ["company_id"], name: "index_people_on_company_id"
  end

  create_table "people_skills", force: :cascade do |t|
    t.boolean "certificate", default: false
    t.boolean "core_competence", default: false
    t.integer "interest"
    t.integer "level"
    t.bigint "person_id"
    t.bigint "skill_id"
    t.boolean "unrated"
    t.index ["person_id"], name: "index_people_skills_on_person_id"
    t.index ["skill_id"], name: "index_people_skills_on_skill_id"
  end

  create_table "person_role_levels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "level", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_roles", force: :cascade do |t|
    t.decimal "percent", precision: 5, scale: 2
    t.bigint "person_id"
    t.integer "person_role_level_id"
    t.bigint "role_id"
    t.index ["person_id"], name: "index_person_roles_on_person_id"
    t.index ["role_id"], name: "index_person_roles_on_role_id"
  end

  create_table "project_technologies", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "offer", default: [], array: true
    t.bigint "project_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["project_id"], name: "index_project_technologies_on_project_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.boolean "display_in_cv", default: true, null: false
    t.integer "month_from"
    t.integer "month_to"
    t.integer "person_id"
    t.text "role"
    t.text "technology"
    t.text "title"
    t.datetime "updated_at", precision: nil, null: false
    t.string "updated_by"
    t.integer "year_from", null: false
    t.integer "year_to"
    t.index ["person_id"], name: "index_projects_on_person_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "default_set"
    t.datetime "discarded_at"
    t.integer "portfolio"
    t.integer "radar"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["category_id"], name: "index_skills_on_category_id"
    t.index ["discarded_at"], name: "index_skills_on_discarded_at"
  end

  create_table "unified_skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "skill1_attrs"
    t.text "skill2_attrs"
    t.text "unified_skill_attrs"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "department_skill_snapshots", "departments"
  add_foreign_key "language_skills", "people"
  add_foreign_key "people", "companies"
  add_foreign_key "project_technologies", "projects"
end
