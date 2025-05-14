require 'rails_helper'

describe 'Department Skill Snapshots', type: :feature, js: true do
  before(:each) do
    admin = auth_users(:admin)
    login_as(admin, scope: :auth_user)
    visit department_skill_snapshots_path
  end

  it 'Should display all labels correctly' do
    expect(page).to have_text('Organisationseinheit')
    expect(page).to have_text('Skill')
    expect(page).to have_text('Jahr')


  end
end
