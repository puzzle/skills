require 'rails_helper'

describe 'Educations', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  describe 'Crud actions' do
    it 'shows all' do
      within('turbo-frame#educations_all') do
        person.educations.each do |education|
          expect(page).to have_content(education.title)
          expect(page).to have_content(education.location)
        end
      end
    end

    it 'creates and saves new education' do
      title = 'Döner-Verkäufer'
      new_location = 'Dönerbude'

      click_link(href: new_person_education_path(person))

      within('turbo-frame#new_education') do
        fill_in 'education_title', with: title
        fill_in 'education_location', with: new_location
        find("button[type='submit']").click
      end

      expect(person.educations.last.title).to eq(title)
      expect(person.educations.last.location).to eq(new_location)
    end

    it 'updates education' do
      updated_location = 'Dönerbude des Vertrauens'

      education = person.educations.first
      within("turbo-frame#education_#{education.id}") do
        find("[href=\"#{edit_person_education_path(person, education)}\"]").all("*").first.click
        fill_in 'education_location', with: updated_location
        find("button[type='submit']").click
      end
      expect(person.educations.first.location).to eq(updated_location)
    end

    it 'cancels without saving' do
      education = person.educations.first
      old_location = education.location
      updated_location = 'Dönerbude des Vertrauens'

      within("turbo-frame#education_#{education.id}") do
        find("[href=\"#{edit_person_education_path(person, education)}\"]").all("*").first.click
        fill_in 'education_location', with: updated_location
        find('a', text: 'Abbrechen').click
      end
      expect(person.educations.first.location).to eq(old_location)
    end
  end

  describe 'Error handling' do
    it 'create new education without title and location' do
      click_link(href: new_person_education_path(person))

      within('turbo-frame#new_education') do
        find("button[type='submit']").click
      end
      expect(page).to have_css(".alert.alert-danger", text: "Title muss ausgefüllt werden")
      expect(page).to have_css(".alert.alert-danger", text: "Location muss ausgefüllt werden")
    end

    it 'Update entry and clear title & description' do
      education = person.educations.first
      within("turbo-frame#education_#{education.id}") do
        find("[href=\"#{edit_person_education_path(person, education)}\"]").all("*").first.click
        fill_in 'education_title', with: ""
        fill_in 'education_location', with: ""
        find("button[type='submit']").click
      end
      expect(page).to have_css(".alert.alert-danger", text: "Title muss ausgefüllt werden")
      expect(page).to have_css(".alert.alert-danger", text: "Location muss ausgefüllt werden")
    end
  end
end