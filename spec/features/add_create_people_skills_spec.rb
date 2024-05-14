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

    it 'Fail while create new skill and add to people-skills' do
      skill_name = "skill_name"
      category = categories(:java)
      within '#remote_modal' do
        select_and_create_skill(skill_name, category)
        select_level(4)
        click_button 'Skill erstellen'
      end
      expect(page).to have_select("people_skill_skill_attributes_id", selected: skill_name, visible:false)
      expect(page).to have_select("people_skill_skill_attributes_category_id", selected: category.name_with_parent)
    end

    it 'Fail while add skill to people-skills' do
      skill = skills(:junit)
      within '#remote_modal' do
        select_skill(skill)
        click_button 'Skill erstellen'
      end
      expect(page).to have_select("people_skill_skill_attributes_id", selected: skill.title, visible:false)
      expect(page).to have_select("people_skill_skill_attributes_category_id", selected: skill.category.name_with_parent, visible: false)
    end

    it 'Fail while add skill to people-skills, intrest should be persisted' do
      within '#remote_modal' do
        select_star_rating(4)
        click_button 'Skill erstellen'
      end
      validate_interest(4)
    end
  end
end
