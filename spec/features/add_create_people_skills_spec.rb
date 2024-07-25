require 'rails_helper'

describe :people do
  describe 'People Skills', type: :feature, js: true do
    let(:person) { people(:bob) }

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
      visit person_people_skills_path(person)
      click_link text: "Skill hinzufügen"
    end

    it 'Adds existing skill to people-skills' do
      skill = skills(:junit)
      within '#remote_modal' do
        select_skill(skill)
        select_level(4)
        select_star_rating(4)
        check("people_skill_certificate")
        check("people_skill_core_competence")
        click_button 'Skill erstellen'
      end
      validate_people_skill(person, skill.title)
    end

    it 'Create new skill and add to people-skills' do
      skill_name = "skill_name"
      category = categories(:java)
      within '#remote_modal' do
        select_and_create_skill(skill_name, category)
        select_level(4)
        select_star_rating(4)
        check("people_skill_certificate")
        check("people_skill_core_competence")
        click_button 'Skill erstellen'
      end
      validate_people_skill(person, skill_name)
    end

    it 'Fail while add skill not selecting skill' do
      within '#remote_modal' do
        select_level(4)
        click_button 'Skill erstellen'
        expect(page).to have_select("people_skill_skill_attributes_id", visible: false)
        expect(page).to have_select("people_skill_skill_attributes_category_id")
      end
    end

    it 'Fail while add skill to people-skills, intrest should be persisted' do
      within '#remote_modal' do
        select_star_rating(3)
        click_button 'Skill erstellen'
      end
      within '#remote_modal' do
        expect(page).to have_content "Skill title muss ausgefüllt werden"
        validate_interest(3)
      end
    end
  end
end
