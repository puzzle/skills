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
end
