require 'rails_helper'


describe 'Advanced Trainings', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit("/cv_search")
  end

  describe 'Search' do
    it 'should find correct results' do
      fill_in 'cv_search_field', with: person.name
      check_search_results(Person.human_attribute_name(:name))
      fill_in 'cv_search_field', with: person.projects.first.technology
      check_search_results(Person.human_attribute_name(:projects))
      fill_in 'cv_search_field', with: person.title
      check_search_results(Person.human_attribute_name(:title))
      fill_in 'cv_search_field', with: person.roles.first.name
      check_search_results(Person.human_attribute_name(:roles))
      fill_in 'cv_search_field', with: person.department.name
      check_search_results(Person.human_attribute_name(:department))
      fill_in 'cv_search_field', with: person.competence_notes.split.first
      check_search_results(Person.human_attribute_name(:competence_notes))
      fill_in 'cv_search_field', with: person.advanced_trainings.first.description
      check_search_results(Person.human_attribute_name(:advanced_trainings))
      fill_in 'cv_search_field', with: person.educations.first.location
      check_search_results(Person.human_attribute_name(:educations))
      fill_in 'cv_search_field', with: person.activities.first.description
      check_search_results(Person.human_attribute_name(:activities))
      fill_in 'cv_search_field', with: person.projects.first.description
    end

    it 'should open person when clicking result' do
      fill_in 'cv_search_field', with: person.projects.first.technology
      check_search_results(Person.human_attribute_name(:projects))
      first("a", text: person.name).click();
      expect(page).to have_current_path(person_path(person))

      visit(cv_search_index_path)
      education_location = person.educations.first.location
      fill_in 'cv_search_field', with: education_location
      check_search_results(Person.human_attribute_name(:educations))
      click_link(Person.human_attribute_name(:educations))
      url = URI.parse(current_url)
      path = url.path
      query_params = url.query.split("&")

      # expect(path).to eq(person_people_skills_path(person))
      expect(path).to include(person.id.to_s)

      expect(query_params).to include({q: education_location}.to_query)
    end

    it 'should only display results when length of search-text is > 3' do
      fill_in 'cv_search_field', with: person.name.slice(0, 2)
      expect(page).not_to have_content(person.name)
      fill_in 'cv_search_field', with: person.name.slice(0, 3)
      expect(page).to have_content(person.name)
    end

    it 'should dynamically search skills' do
      skill_title = person.skills.last.title
      fill_in 'cv_search_field', with: skill_title
      expect(page).to have_content("Keine Resultate")
      page.check('search_skills')
      expect(page).not_to have_content("Keine Resultate")
      check_search_results(Skill.model_name.human(count: 2))
      link = person_people_skills_path(person, q: skill_title, rating: 1)
      expect(page).to have_link(href: link)
    end
  end
end

def check_search_results(field_name)
  within('turbo-frame#search-results') {
    expect(page).to have_content(person.name)
    expect(page).to have_content(field_name)
  }
end
