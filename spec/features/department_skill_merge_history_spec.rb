# frozen_string_literal: true

require "rails_helper"

describe "Department Merge History", type: :feature, js: true do
  include SlimselectHelpers

  before do
    sign_in auth_users(:admin)
  end

  def merge_departments(old_departments:, new_department:)
    visit new_admin_merge_department_skill_snapshot_path

    multi_select_from_slim_select(
      "#merge_department_skill_form_old_department_ids",
      old_departments.map(&:name)
    )

    select_from_slim_select(
      "#merge_department_skill_form_new_department_id",
      new_department.name
    )

    accept_alert do
      click_button(t("admin/merge_department_skill_snapshots.form.department_merge"))
    end
  end

  it "creates and displays merge history entries in the table" do
    dev_one = departments(:"dev-one")
    dev_two = departments(:"dev-two")
    sys = departments(:sys)

    ux = departments(:ux)
    mid = departments(:mid)

    merge_departments(
      old_departments: [dev_one, dev_two],
      new_department: sys
    )

    merge_departments(
      old_departments: [ux, mid],
      new_department: sys
    )

    within "#department_merge_history" do
      within "table tbody" do
        expect(page).to have_selector("tr", minimum: 2)
        rows = all("tr")
        expect(rows.size).to be >= 2

        first_row = rows.first

        within first_row do
          expect(page).to have_content(sys.name)
          expect(page).to have_content(dev_one.name).or have_content(ux.name)
          expect(page).to have_content(dev_two.name).or have_content(mid.name)
        end
      end
    end
  end

  it "shows empty state when no merges exist" do
    visit new_admin_merge_department_skill_snapshot_path

    within "#department_merge_history" do
      expect(page).to have_content(
                        t("admin/merge_department_skill_snapshots.index.department_merge_history.no_departments_merged")
                      )
    end
  end
end