require 'rails_helper'


describe 'Advanced Trainings', type: :feature, js:true do
  let(:bob) { people(:bob) }
  let(:alice) { people(:alice) }

  before(:each) do
    sign_in auth_users(:admin)
    visit("/cv_search")
  end

  describe 'Search' do
    it 'should find correct results' do
      fill_in 'cv_search_field', with: bob.name
      check_search_results(Person.human_attribute_name(:name))
      fill_in 'cv_search_field', with: bob.projects.first.technology
      check_search_results(Person.human_attribute_name(:projects))
      fill_in 'cv_search_field', with: bob.title
      check_search_results(Person.human_attribute_name(:title))
      fill_in 'cv_search_field', with: bob.roles.first.name
      check_search_results(Person.human_attribute_name(:roles))
      fill_in 'cv_search_field', with: bob.department.name
      check_search_results(Person.human_attribute_name(:department))
      fill_in 'cv_search_field', with: bob.competence_notes.split.first
      check_search_results(Person.human_attribute_name(:competence_notes))
      fill_in 'cv_search_field', with: bob.advanced_trainings.first.description
      check_search_results(Person.human_attribute_name(:advanced_trainings))
      fill_in 'cv_search_field', with: bob.educations.first.location
      check_search_results(Person.human_attribute_name(:educations))
      fill_in 'cv_search_field', with: bob.activities.first.description
      check_search_results(Person.human_attribute_name(:activities))
      fill_in 'cv_search_field', with: bob.projects.first.description
    end

    it 'should open person when clicking result' do
      fill_in 'cv_search_field', with: bob.projects.first.technology
      check_search_results(Person.human_attribute_name(:projects))
      # Tests are flaky in firefox
      sleep 0.3
      click_link bob.name
      expect(page).to have_current_path(person_path(bob))

      visit(cv_search_index_path)
      education_location = bob.educations.first.location
      fill_in 'cv_search_field', with: education_location
      check_search_results(Person.human_attribute_name(:educations))
      # Tests are flaky in firefox
      sleep 0.3
      click_link(Person.human_attribute_name(:educations))
      expect(page).to have_current_path(person_path(bob, q: education_location, section_id: "educations"))
    end

    it 'should only display results when length of search-text is > 3' do
      fill_in 'cv_search_field', with: bob.name.slice(0, 2)
      expect(page).not_to have_content(bob.name)
      fill_in 'cv_search_field', with: bob.name.slice(0, 3)
      expect(page).to have_content(bob.name)
    end

    it 'should dynamically search skills' do
      skill_title = bob.skills.last.title
      fill_in 'cv_search_field', with: skill_title
      expect(page).to have_content("Keine Resultate")
      page.check('search_skills')
      expect(page).not_to have_content("Keine Resultate")
      check_search_results(Skill.model_name.human.pluralize)
      expect(page).to have_link(href: /#{person_people_skills_path(bob)}.*q=#{skill_title}/)
    end

    it "should highlight the correct text" do
      target = "Ruby"

      visit(cv_search_index_path)
      fill_in 'cv_search_field', with: target

      # Tests are flaky in firefox
      sleep 0.3
      click_link "Projekte"

      expect(page).to have_current_path(person_path(bob, q: target, section_id: "projects"))
      within "#projects"
      expect(page).to have_selector('mark.p-1.rounded', text: target)
    end

    it 'should show multiple found skills and with category' do
      first_skill = 'Java'
      second_skill = 'Javascript'

      visit skills_path

      rename_skill_with(first_skill, Skill.first)
      rename_skill_with(second_skill, Skill.fourth, 'System-Engineering')

      visit cv_search_index_path

      fill_in 'cv_search_field', with: first_skill
      check 'search_skills'

      expected_url = /#{person_people_skills_path(alice)}.*q=#{first_skill}/
      expect(page).to have_link(href: expected_url)

      skills_label = Skill.model_name.human.pluralize
      check_search_results("#{skills_label}/ #{alice.skills.first.parent_category.title}", alice)
    end
  end
end

def rename_skill_with(name, skill, category = 'Software-Engineering')
  within "#skill_#{skill.id}" do
    find('.icon.icon-pencil').click
    fill_in 'skill_title', with: name
    select category, from: 'skill_category_parent'
    find("input[type='image']").click
  end
end

def check_search_results(field_name, person = bob)
  within('turbo-frame#search-results') {
    expect(page).to have_link(person.name)
    expect(page).to have_link(field_name)
  }
end
