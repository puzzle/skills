# frozen_string_literal: true

require "rails_helper"

describe "Merge Department Skill Snapshots", type: :feature, js: true do
  before(:each) do
    sign_in auth_users(:admin)
    visit new_admin_merge_department_skill_snapshots_path
  end

  def merge_departments(old_departments:, new_department:)
    old_departments.each do |department|
      select_from_slim_select(
        "#merge_department_skill_form_old_department_ids",
        department.name
      )
    end

    select_from_slim_select(
      "#merge_department_skill_form_new_department_id",
      new_department.name
    )

    click_button "Verlauf zusammenführen"
  end

  it "merges departments successfully" do
    dev_one = departments(:"dev-one")
    dev_two = departments(:"dev-two")
    sys = departments(:sys)

    merge_departments(
      old_departments: [dev_one, dev_two],
      new_department: sys
    )

    expect(page).to have_content(dev_one.name)
    expect(page).to have_content(dev_two.name)
    expect(page).to have_content(sys.name)

    expect(page).to have_current_path(
                      new_admin_merge_department_skill_snapshots_path
                    )
  end

  it "submits successfully with default target department" do
    click_button "Verlauf zusammenführen"

    expect(page).to have_content("Alte Abteilungen muss ausgefüllt werden")
  end

  it "shows validation error when same department is selected" do
    dev_one = departments(:"dev-one")

    form = MergeDepartmentSkillForm.new(
      old_department_ids: [dev_one.id],
      new_department_id: dev_one.id
    )
    form.valid?

    merge_departments(
      old_departments: [dev_one],
      new_department: dev_one
    )

    form.errors.full_messages.each do |error_message|
      expect(page).to have_content(error_message)
    end
  end
end