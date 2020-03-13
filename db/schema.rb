# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_01_142938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.text "description"
    t.string "updated_by"
    t.text "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.integer "year_from", null: false
    t.integer "year_to"
    t.integer "month_from"
    t.integer "month_to"
    t.index ["person_id"], name: "index_activities_on_person_id"
  end

  create_table "advanced_trainings", id: :serial, force: :cascade do |t|
    t.text "description"
    t.string "updated_by"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year_from", null: false
    t.integer "year_to"
    t.integer "month_from"
    t.integer "month_to"
    t.index ["person_id"], name: "index_advanced_trainings_on_person_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "educations", id: :serial, force: :cascade do |t|
    t.text "location"
    t.text "title"
    t.datetime "updated_at"
    t.string "updated_by"
    t.integer "person_id"
    t.integer "year_from", null: false
    t.integer "year_to"
    t.integer "month_from"
    t.integer "month_to"
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

  create_table "language_skills", force: :cascade do |t|
    t.string "language"
    t.string "level"
    t.string "certificate"
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_language_skills_on_person_id"
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
    t.string "competence_notes"
    t.datetime "associations_updatet_at"
    t.string "nationality"
    t.string "nationality2"
    t.integer "marital_status", default: 0, null: false
    t.string "email"
    t.integer "department_id"
  end

  create_table "people_skills", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "skill_id"
    t.integer "level"
    t.integer "interest"
    t.boolean "certificate", default: false
    t.boolean "core_competence", default: false
    t.index ["person_id"], name: "index_people_skills_on_person_id"
    t.index ["skill_id"], name: "index_people_skills_on_skill_id"
  end

  create_table "person_role_levels", force: :cascade do |t|
    t.string "level", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "person_roles", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "role_id"
    t.decimal "percent", precision: 5, scale: 2
    t.integer "person_role_level_id"
    t.index ["person_id"], name: "index_person_roles_on_person_id"
    t.index ["role_id"], name: "index_person_roles_on_role_id"
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
    t.integer "year_from", null: false
    t.integer "year_to"
    t.integer "month_from"
    t.integer "month_to"
    t.index ["person_id"], name: "index_projects_on_person_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "title"
    t.integer "radar"
    t.integer "portfolio"
    t.boolean "default_set"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_skills_on_category_id"
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "language_skills", "people"
  add_foreign_key "project_technologies", "projects"
end
