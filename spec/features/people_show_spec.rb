require 'rails_helper'

describe 'People skills Show', type: :feature, js: true do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
    visit root_path
  end

  it 'Should only display valid amount of members' do
      visit skills_path
      click_link('Rails')
      expect(page.find('.modal-title', text: 'Skill: Rails (5 Members)'))
      expect(page).to have_selector('.skill-row', count: 5)
  end

  it 'Should render elements correctly' do
    visit skills_path
    click_link('Bash')
    expect(page).to have_text('Skill: Bash (1 Members)')
    expect(page).to have_xpath("//input[@value=5]")
    expect(page).to have_xpath("//input[@value=2]")
    expect(page.first(".certificate")).to be_checked
    expect(page.first(".core-competence")).not_to be_checked
  end
end
