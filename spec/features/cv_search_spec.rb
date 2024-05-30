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
      check_search_results(I18n.t("cv_search.name"))
      fill_in 'cv_search_field', with: person.projects.first.technology
      check_search_results(I18n.t("cv_search.projects"))
      fill_in 'cv_search_field', with: person.title
      check_search_results(I18n.t("cv_search.title"))
      fill_in 'cv_search_field', with: person.roles.first.name
      check_search_results(I18n.t("cv_search.roles"))
      fill_in 'cv_search_field', with: person.department.name
      check_search_results(I18n.t("cv_search.department"))
      fill_in 'cv_search_field', with: person.competence_notes.split.first
      check_search_results(I18n.t("cv_search.competence_notes"))
      fill_in 'cv_search_field', with: person.advanced_trainings.first.description
      check_search_results(I18n.t("cv_search.advanced_trainings"))
      fill_in 'cv_search_field', with: person.educations.first.location
      check_search_results(I18n.t("cv_search.educations"))
      fill_in 'cv_search_field', with: person.activities.first.description
      check_search_results(I18n.t("cv_search.activities"))
      fill_in 'cv_search_field', with: person.projects.first.description
      check_search_results(I18n.t("cv_search.projects"))
    end

    it 'should open person when clicking result' do
      fill_in 'cv_search_field', with: person.projects.first.technology
      check_search_results(I18n.t("cv_search.projects"))
      click_link(person.name)
      expect(page).to have_current_path(person_path(person))

      visit("/cv_search")
      education_location = person.educations.first.location
      fill_in 'cv_search_field', with: education_location
      check_search_results(I18n.t("cv_search.educations"))
      click_link(I18n.t("cv_search.educations"))
      expect(page).to have_current_path("#{person_path(person)}")
    end

    it 'should only display results when length of search-text is > 3' do
      fill_in 'cv_search_field', with: person.name.slice(0, 2)
      expect(page).not_to have_content(person.name)
      fill_in 'cv_search_field', with: person.name.slice(0, 3)
      expect(page).to have_content(person.name)
    end
  end
end

def check_search_results(field_name)
  within('turbo-frame#search-results') {
    expect(page).to have_content(person.name)
    expect(page).to have_content(field_name)
  }
end
