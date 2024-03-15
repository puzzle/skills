require 'rails_helper'

describe :people do
  describe 'People Search', type: :feature, js: true do

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
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

  def fill_out_person_form
    page.attach_file("avatar-uploader", Rails.root + 'app/assets/images/1.png')
    fill_in 'person_name', with: 'Hansjakobli'
    fill_in 'person_email', with: 'hanswurst@somemail.com'
    fill_in 'person_title', with: 'Wurstexperte'
    page.first(".add_fields").click
    role_select = page.all('.role-select').last
    role_level_select = page.all('.role-level-select').last
    role_percent_select = page.all('.person-role-percent').last
    select 'System-Engineer', from: role_select[:id]
    select 'S3', from: role_level_select[:id]
    fill_in role_percent_select[:id], with: '80'

    select '/ux', from: 'person_department_id'
    select 'Partner', from: 'person_company_id'
    fill_in 'person_location', with: 'Las Vegas'
    fill_in 'person_birthdate', with: '1979-03-28'.to_date
    check 'nat-two-checkbox'
    select ISO3166::Country["DE"].translations[I18n.locale], from: 'person_nationality'
    select ISO3166::Country["US"].translations[I18n.locale], from: 'person_nationality2'
    select I18n.t('marital_statuses.married'), from: 'person_marital_status'
    fill_in 'person_shortname', with: 'bb'
  end

  describe 'Edit person', type: :feature, js: true do
    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'should have all edit fields' do
      bob = people(:bob)
      visit person_path(bob)
      page.find('#edit-button').click
      expect(page).to have_field('avatar-uploader')
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
      expect(page).to have_select('person_nationality', selected: ISO3166::Country[bob.nationality].translations[I18n.locale])
      bob.nationality2.nil? ? (expect(page).not_to have_select('person_nationality2')) : (expect(page).to have_select('person_nationality2', selected: ISO3166::Country[bob.nationality2].translations[I18n.locale]))
      expect(page).to have_select('person_marital_status', selected: I18n.t("marital_statuses.#{bob.marital_status}"))
      expect(page).to have_field('person_shortname', with: bob.shortname)
    end

    it 'should edit and save changes' do
      bob = people(:bob)
      visit person_path(bob)
      page.find('#edit-button').click
      fill_out_person_form
      page.find("#save-button").click

      expect(page).to have_content("Hansjakobli")

      edited_person = Person.find_by(name: 'Hansjakobli')
      expect(edited_person.picture.identifier).to eql('1.png')
      expect(edited_person.email).to eql('hanswurst@somemail.com')
      expect(edited_person.title).to eql('Wurstexperte')
      expect(edited_person.person_roles.count).to eql(3)
      edited_person_role = edited_person.person_roles.last
      expect(edited_person_role.role.name).to eql('System-Engineer')
      expect(edited_person_role.person_role_level.level).to eql('S3')
      expect(edited_person_role.percent).to eq(80)
      expect(edited_person.department.name).to eql('/ux')
      expect(edited_person.company.name).to eql('Partner')
      expect(edited_person.location).to eql('Las Vegas')
      expect(edited_person.birthdate.to_date.strftime('%d.%m.%Y')).to eql('28.03.1979')
      expect(edited_person.nationality).to eql('DE')
      expect(edited_person.nationality2).to eql('US')
      expect(edited_person.marital_status).to eql('married')
      expect(edited_person.shortname).to eql('bb')
    end

    it 'should edit and cancel without saving' do
      person = Person.first
      visit person_path(person)
      page.find('#edit-button').click
      fill_out_person_form
      page.find('#cancel-button').click
      expect(person.attributes).to eql(Person.first.attributes)
    end
  end
end
