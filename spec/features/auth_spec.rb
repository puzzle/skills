require 'rails_helper'

describe 'Check authentications', type: :feature, js: true do
  context 'Check user privileges' do

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
      visit root_path
    end

    it 'Username field does not contain admin tag' do
      expect(page.find('#username').text).not_to end_with("(Admin)")
    end

    it 'Cannot create new skill' do
      visit skills_path
      click_link(href: new_skill_path)
      expect(page).to have_content("401 Keine ausreichenden Berechtigungen")
    end
  end


  context 'Check admin privileges' do

    before(:each) do
      sign_in(auth_users(:admin))
      visit visit people_path
    end

    it 'Username field contains admin tag' do
      expect(page.find('#username').text).to end_with("(Admin)")
    end

    it 'Admin can create new skill' do
      visit skills_path
      click_link(href: new_skill_path)
      expect(page).to have_field('skill_title')
    end
  end

  context 'Already logged in' do

    before(:each) do
      sign_in(auth_users(:admin))
      visit new_auth_user_session_path
    end

    it 'should show flash when user tries to log in but is already logged in' do
      expect(page).to have_css('.alert-success', text: 'Sie sind bereits angemeldet.')
    end
  end
end
