require 'rails_helper'

describe 'Department Skill Snapshots', type: :feature, js: true do
  before(:each) do
    admin = auth_users(:admin)
    login_as(admin, scope: :auth_user)
    visit department_skill_snapshots_path
  end

  it 'Should display all selects with the corresponding labels and the canvas chart' do
    expect(page).to have_content('Organisationseinheit')
    expect(page).to have_content('Skill')
    expect(page).to have_content('Jahr')
    expect(page).to have_field('department_id', visible: :hidden)
    expect(page).to have_field('skill_id', visible: :hidden)

    expect(page).to have_select('year')
    expect(page).to have_select('chart_type')

    expect(page).to have_selector("canvas")
  end

  it "successfully searches and selects a department from the dropdown" do
    department = departments(:sys)
    department_slim_select = page.find_all('.ss-main')[0]
    department_slim_select.click

    department_search_input = page.find('.ss-search')
    department_search_input.fill_in with: department.name

    page.find('.ss-option', text: department.name).click

    expect(page).to have_field('department_id', with: department.id.to_s, visible: :hidden)
  end

  it "successfully searches and selects a skill from the dropdown" do
    skill = skills(:junit)
    skill_slim_select = page.find_all('.ss-main')[1]
    skill_slim_select.click

    skill_search_input = page.find('.ss-search')
    skill_search_input.fill_in with: skill.title

    page.find('.ss-option', text: skill.title).click

    expect(page).to have_field('skill_id', with: skill.id.to_s, visible: :hidden)
  end
end
