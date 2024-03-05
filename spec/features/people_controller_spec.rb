require 'rails_helper'

describe :people do
  describe 'People Search', type: :feature, js: true do

    before(:each) do
      user = auth_users(:user)
      login_as(user, scope: :auth_user)
    end

    let(:list) {Person.all.sort_by(&:name) }

    it 'displays people in alphabetical order in select' do
      visit people_path
      within 'section[data-controller="dropdown"]' do
        dropdown_options = list.pluck(:name).unshift("Bitte wählen")
        expect(page).to have_select('person_id', options: dropdown_options, selected: "Bitte wählen")
      end
    end


    it 'redirects to the selected person on change' do
      bob = people(:bob)
      visit people_path
      within 'section[data-controller="dropdown"]' do
        select bob.name, from: 'person_id'
      end

      expect(page).to have_current_path(person_path(bob))
      expect(page).to have_select('person_id', selected: bob.name)
    end

    it 'redirect to the first entry ' do
      visit people_path
      within 'section[data-controller="dropdown"]' do
        first('#person_id option:enabled', minimum: 1).select_option
      end
      expect(page).to have_current_path(person_path(list.first))
      expect(page).to have_select('person_id', selected: list.first.name)
    end
  end

  describe 'Edit person', type: :feature, js: true do
    it 'can edit person' do
      bob = people(:bob)
      visit person_path(bob)
      page.first('.edit_button').click
      expect(page).to have_field('person_name', with: bob.name)
      expect(page).to have_field('person_email', with: bob.email)
      expect(page).to have_field('person_title', with: bob.title)
      person_roles = bob.person_roles
      role_selects = page.all('.role-select')
      role_level_selects = page.all('.role-level-select')
      role_percent_selects = page.all('.person-role-percent')
      expect(role_selects.count).to equal(person_roles.count)
      expect(role_level_selects.count).to equal(person_roles.count)
      expect(role_percent_selects.count).to equal(person_roles.count)
      role_selects.each_with_index do |role_select, i|
        expect(role_select.value.to_i).to equal(person_roles[i].role_id)
      end
      role_level_selects.each_with_index do |role_level_select, i|
        person_roles[i].person_role_level_id.nil? ? (expect(role_level_select.value.to_i).to equal(PersonRoleLevel.first.id)) : (expect(role_level_select.value.to_i).to equal(person_roles[i].person_role_level_id))
      end
      role_percent_selects.each_with_index do |role_percent_select, i|
        expect(role_percent_select.value.to_i).to equal(person_roles[i].percent.to_i)
      end
      expect(page).to have_select('person_department_id', selected: bob.department.name)
      expect(page).to have_select('person_company_id', selected: bob.company.name)
      expect(page).to have_field('person_location', with: bob.location)
      expect(page).to have_field('person_birthdate', with: bob.birthdate.to_date.strftime)
      expect(page).to have_field('nat-two-checkbox', with: bob.nationality2.nil? ? "0" : "1")
      expect(page.all('.nationality-two').count).to equal(bob.nationality2.nil? ? 0 : 2)
      expect(page).to have_select('person_nationality', selected: ISO3166::Country[bob.nationality]&.iso_short_name)
      bob.nationality2.nil? ? (expect(page).not_to have_select('person_nationality2')) : (expect(page).to have_select('person_nationality2', selected: ISO3166::Country[bob.nationality2]&.iso_short_name))
      expect(page).to have_select('person_marital_status', selected: bob.marital_status)
    end
  end
end
