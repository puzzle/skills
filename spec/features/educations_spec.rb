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

<<<<<<< HEAD
      open_create_form(Education)
=======
      open_create_dialogue("Ausbildung hinzufügen", "#education_title")
>>>>>>> Move code to savely open person_relation create field to helper method and use helper method in specs

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

  describe 'Error handling' do
    it 'create new education without title and location' do
<<<<<<< HEAD
      open_create_form(Education)
=======
      open_create_dialogue("Ausbildung hinzufügen", "#education_title")
>>>>>>> Move code to savely open person_relation create field to helper method and use helper method in specs

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
  end

  def click_default_submit
    find("button[type='submit'][name='save']").click
  end

  def click_save_and_new_submit
    find("button[type='submit'][name='render_new_after_save']").click
  end
end
