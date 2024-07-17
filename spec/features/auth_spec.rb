require 'rails_helper'

describe 'Check authentications', type: :feature, js: true do
  context 'Check user privileges' do

    before(:each) do
      set_env_variables_and_stub_request
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
      set_env_variables_and_stub_request
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
end
