require 'rails_helper'

describe 'People skills Show', type: :feature, js: true do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
    visit root_path
  end

  it 'Should render elements correctly' do
      visit skills_path
      click_link('Bash')
      expect(page).to have_text('Skill: Bash (1 Members)')
      expect(page).to have_xpath("//input[@value=5]")
      expect(page).to have_xpath("//input[@value=2]")
  end
end
