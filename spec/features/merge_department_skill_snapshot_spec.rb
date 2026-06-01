# frozen_string_literal: true

require "rails_helper"

describe "Merge Department Skill Snapshots", type: :feature, js: true do
  include SlimselectHelpers

  before(:each) do
    sign_in auth_users(:admin)
    visit new_admin_merge_department_skill_snapshot_path
  end

  def multi_select_from_slim_select(selector, texts)
    available_options = ss_options(selector)

    option_values = texts.map do |text|
      matched_option = available_options.find { |opt| opt["text"] == text }

      matched_option["value"]
    end

    script = "document.querySelector('#{selector}').slim.setSelected(#{option_values.to_json})"
    evaluate_script(script)

    select_element = find(selector, visible: false)
    expect(select_element.value).to match_array(option_values)
  end

  def merge_department_snapshots(old_departments:, new_department:)
    multi_select_from_slim_select(
      "#merge_department_skill_form_old_department_ids",
      old_departments.map(&:name)
    )

    select_from_slim_select(
      "#merge_department_skill_form_new_department_id",
      new_department.name
    )
    accept_alert do
      click_button(t('admin/merge_department_skill_snapshots.form.department_merge'))
    end
  end

  it "merges departments successfully" do
    dev_one = departments(:"dev-one")
    dev_two = departments(:"dev-two")
    sys = departments(:sys)

    merge_department_snapshots(
      old_departments: [dev_one, dev_two],
      new_department: sys
    )

    within ".alert, .flash, .notice" do
      expect(page).to have_content(dev_two.name)
      expect(page).to have_content(dev_one.name)
      expect(page).to have_content(sys.name)
    end

    expect(page).to have_current_path(
                      new_admin_merge_department_skill_snapshot_path
                    )
  end

  it "shows validation when old departments are not set with default target department" do
    accept_alert do
      click_button(t('admin/merge_department_skill_snapshots.form.department_merge'))
    end

    expect(page).to have_content("Alte Abteilungen muss ausgefüllt werden")
  end

  it "shows validation error when same department is selected" do
    dev_one = departments(:"dev-one")

    form = MergeDepartmentSkillForm.new(
      old_department_ids: [dev_one.id],
      new_department_id: dev_one.id
    )
    form.valid?

    merge_department_snapshots(
      old_departments: [dev_one],
      new_department: dev_one
    )

    form.errors.full_messages.each do |error_message|
      expect(page).to have_content(error_message)
    end
  end
end