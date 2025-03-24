require 'rails_helper'

describe :people do
  describe 'filter people skills by rating', type: :feature, js: true do
    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'filters people skills correctly' do
      person = people(:alice)
      visit person_people_skills_path(person)

      person_skills = person.people_skills

      find("label[for='rating_1']").click
      person_skills.each do |person_skill|
        expect(page).to have_text(person_skill.skill.title)
      end

      find("label[for='rating_0']").click
      sleep(0.3)
      person_skills.each do |person_skill|
        expect(page.has_text?(person_skill.skill.title, wait: 0.1)).to eql(person_skill.level != 0)
      end

      find("label[for='rating_-1']").click
      sleep(0.3)
      person_skills.each do |person_skill|
        expect(page.has_text?(person_skill.skill.title, wait: 0.1)).to eql(person_skill.level == 0)
      end
    end

    it 'sets correct action link on default skill forms when changing filter' do
      person = people(:longmax)
      visit person_people_skills_path(person)

      within('#people-skill-form') do
        expect(page).to have_css("form[action*='?rating=0']")
      end

      find("label[for='rating_1']").click

      within('#people-skill-form') do
        expect(page).to have_css("form[action*='?rating=1']")
      end

      find("label[for='rating_-1']").click

      within('#people-skill-form') do
        expect(page).to have_css("form[action*='?rating=-1']")
      end
    end
  end
end