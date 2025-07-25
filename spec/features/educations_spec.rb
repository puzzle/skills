require 'rails_helper'

describe 'Educations', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  describe 'Crud actions' do
    it 'shows all' do
      within('turbo-frame#education') do
        person.educations.each do |education|
          expect(page).to have_content(education.title)
          expect(page).to have_content(education.location)
        end
      end
    end

    it 'creates and saves new education' do
      title = 'Döner-Verkäufer'
      new_location = 'Dönerbude'

      open_create_form(Education)

      within('turbo-frame#new_education') do
        select '2024', from: 'education_year_from'
        fill_in 'education_title', with: title
        fill_in 'education_location', with: new_location
        click_default_submit
      end

      expect(page).to have_content(title)
      expect(page).to have_content(new_location)
    end

    it 'updates education' do
      updated_location = 'Dönerbude des Vertrauens'

      education = person.educations.first
      open_edit_form(education)
      within("turbo-frame#education_#{education.id}") do
        fill_in 'education_location', with: updated_location
        click_default_submit
      end
      expect(page).to have_content(updated_location)
    end

    it 'cancels without saving' do
      education = person.educations.first
      old_location = education.location
      updated_location = 'Dönerbude des Vertrauens'

      open_edit_form(education)

      within("turbo-frame#education_#{education.id}") do
        fill_in 'education_location', with: updated_location
        find('a', text: 'Abbrechen').click
      end
      expect(person.educations.first.location).to eq(old_location)
    end
  end

  describe 'Date picker functionality' do
    it 'should copy value of month_from and year_from when values are entered first and button is clicked afterwards' do
      open_create_form(Education)

      within('turbo-frame#new_education') do
        select '2024', from: 'education_year_from'
        select 'Mai', from: 'education_month_from'

        find('button', text: 'Mit Enddatum').click
      end

      expect(find('select', id: 'education_year_to').value).to eq('2024')
      expect(find('select', id: 'education_month_to').value).to eq('5')
    end

    it 'should not copy values when button is opened first and values are entered afterwards' do
      open_create_form(Education)

      within('turbo-frame#new_education') do
        find('button', text: 'Mit Enddatum').click

        select '2024', from: 'education_year_from'
        select 'Mai', from: 'education_month_from'
      end

      expect(find('select', id: 'education_year_to').value).not_to eq('2024')
      expect(find('select', id: 'education_month_to').value).not_to eq('5')
    end
  end

  describe 'Error handling' do
    it 'create new education without title and location' do
      open_create_form(Education)

      within('turbo-frame#new_education') do
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: "Ausbildung muss ausgefüllt werden")
      expect(page).to have_css(".alert.alert-danger", text: "Ausbildungsort muss ausgefüllt werden")
    end

    it 'Update entry and clear title & description' do
      education = person.educations.first
      open_edit_form(education)
      within("turbo-frame#education_#{education.id}") do
        fill_in 'education_title', with: ""
        fill_in 'education_location', with: ""
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: "Ausbildung muss ausgefüllt werden")
      expect(page).to have_css(".alert.alert-danger", text: "Ausbildungsort muss ausgefüllt werden")
    end

    it 'Update entry to not be displayed in the CV' do
      education = person.educations.first
      open_edit_form(education)
      checkbox = find('#education_display_in_cv')
      within("turbo-frame#education_#{education.id}") do
        checkbox.click
        click_default_submit
        expect(page).to have_css("img[src*='no-file']")
      end
      open_edit_form(education)
      expect(checkbox).not_to be_checked
    end
  end
end
