require 'rails_helper'

describe :people do
  describe 'People Skills', type: :feature, js: true do
    let(:person) { people(:bob) }

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'displays people-skills' do
      # Switch to PeopleSkills tab
      bob = people(:bob)
      visit people_path
      page.find('.ss-main').click
      # Select option from dropdown
      page.find(".ss-option", text: bob.name).click
      page.all('.nav-link', text: 'Skills')[1].click

      expect(page).to have_content('Rails')
      expect(page).to have_content('Professional')
      expect(page).to have_selector("input[value='3']")
      checkboxes = page.all('.check_box')
      expect(checkboxes[0]).not_to be_checked
      expect(checkboxes[1]).to be_checked
    end

    it 'can edit people-skills' do
      # Switch to PeopleSkills tab
      alice = people(:alice)
      visit people_path
      page.find('.ss-main').click
      page.find(".ss-option", text: alice.name).click

      # Modify people skills
      page.all('.nav-link', text: 'Skills')[1].click
      page.find('a', text: 'Skills bearbeiten').click
      page.find('#person_people_skills_attributes_0_level').set(5)
      page.find('#person_people_skills_attributes_1_level').set(5)
      page.find('#person_people_skills_attributes_2_level').set(5)
      page.find('#person_people_skills_attributes_3_level').set(5)

      page.find("#person_people_skills_attributes_0_certificate").check
      page.find("#person_people_skills_attributes_2_core_competence").check
      page.find("#person_people_skills_attributes_3_certificate").check
      page.find("#person_people_skills_attributes_3_core_competence").check

      stars = page.all(".star5", visible: false)
      stars.each do |star|
        star.click(x: 10, y: 10)
      end

      # Save changes
      page.find('#save-button').click
      page.find('a', text: 'Skills bearbeiten')

      # Check if changes were saved
      alice.people_skills.each do | person_skill |
        expect(person_skill.level).to eql(5)
        expect(person_skill.certificate).to eql(true)
        expect(person_skill.core_competence).to eql(true)
        expect(person_skill.interest).to eql(5)
      end
    end

    it 'should show amount of skills' do
      # Switch to PeopleSkills tab
      alice = people(:alice)
      visit people_path
      page.find('.ss-main').click
      page.find(".ss-option", text: alice.name).click
      page.all('.nav-link', text: 'Skills')[1].click
      expect(page).to have_content('Ruby (2)')
      expect(page).to have_content('Java (1)')
      expect(page).to have_content('c (0)')
      expect(page).to have_content('Linux-Engineering (1)')
    end

    it 'should display unweighted label if level is 0' do
      # Switch to PeopleSkills tab
      alice = people(:alice)
      visit people_path
      page.find('.ss-main').click
      page.find(".ss-option", text: alice.name).click
      page.all('.nav-link', text: 'Skills')[1].click
      expect(page).to have_content('Unweighted', count: 2)
    end
  end
end
