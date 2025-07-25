require 'rails_helper'

describe 'Advanced Trainings', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  describe 'Simple interactions' do
    it 'shows all' do
      within('turbo-frame#advanced_training') do
        expect(page).to have_content('2010 - 2012')
        expect(page).to have_content('Course about how to clean')
      end
    end

    it 'Create new' do
      description = "new description"

      open_create_form(AdvancedTraining)

      within('turbo-frame#new_advanced_training') do
        fill_in 'advanced_training_description', with: description
        select '2020', from: 'advanced_training_year_from'
        click_default_submit
      end
      expect(page).to have_content(description)
    end

    it 'Create new with save & new' do
      description = "This is a new description created by the save & new functionallity"
      open_create_form(AdvancedTraining)

      within('turbo-frame#new_advanced_training') do
        fill_in 'advanced_training_description', with: description
        select 'Januar', from: 'advanced_training_month_from'
        select '2020', from: 'advanced_training_year_from'

        click_save_and_new_submit
      end
      expect(page).to have_content(description)
      expect(page).to have_select('advanced_training_year_from', selected: "")
      expect(page).to have_select('advanced_training_month_from', selected: "-")
      expect(page).to have_field('advanced_training_description', with: "")
    end

    it 'Update entry' do
      description = "updated description"
      at = person.advanced_trainings.first
      open_edit_form(at)
      within("turbo-frame#advanced_training_#{at.id}") do
        fill_in 'advanced_training_description', with: description
        click_default_submit
        expect(page).to have_content(description)
      end
    end
  end

  describe 'Test dateranger picker' do

    let(:at) { person.advanced_trainings.first }

    before(:each) do
      open_edit_form(at)
      fill_in 'advanced_training_description', with: "This description"
    end

    it 'Update entry and clear description' do
      within("turbo-frame#advanced_training_#{at.id}") do

        click_button(text:"Bis Heute")
        expect(page).to have_selector("select#advanced_training_year_to", visible: :hidden)
        expect(page).to have_selector("select#advanced_training_month_to", visible: :hidden)
        expect(page).to have_content("Bis Heute")

        click_button(text:"Mit Enddatum")

        expect(page).to have_selector("select#advanced_training_year_to", visible: true )
        expect(page).to have_selector("select#advanced_training_month_to", visible: true )
      end
    end
  end

  describe 'Error handling' do

    it 'Create new without description' do
      open_create_form(AdvancedTraining)
      within('turbo-frame#new_advanced_training') do
        select '2020', from: 'advanced_training_year_from'

        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: /Beschreibung muss ausgefüllt werden/)
    end

    it 'year_from cant be empty' do
      open_create_form(AdvancedTraining)
      within('turbo-frame#new_advanced_training') do
        fill_in 'advanced_training_description', with: "This description"

        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: /Startdatum muss ausgefüllt werden/)
    end

    it 'Update entry and clear description' do
      at = person.advanced_trainings.first

      open_edit_form(at)
      within("turbo-frame#advanced_training_#{at.id}") do
        fill_in 'advanced_training_description', with: ""
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: /Beschreibung muss ausgefüllt werden/)
    end

    it 'Update entry and clear description' do
      at = person.advanced_trainings.first
      open_edit_form(at)
      within("turbo-frame#advanced_training_#{at.id}") do
        fill_in 'advanced_training_description', with: "This is a test"
        select '2020', from: 'advanced_training_year_from'
        select '2010', from: 'advanced_training_year_to'
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: /Startdatum muss vor dem Enddatum sein/)
    end

    it 'Update entry to not be displayed in the CV' do
      at = person.advanced_trainings.first
      open_edit_form(at)
      checkbox = find('#advanced_training_display_in_cv')
      within("turbo-frame#advanced_training_#{at.id}") do
        checkbox.click
        click_default_submit
        expect(page).to have_css("img[src*='no-file']")
      end
      open_edit_form(at)
      expect(checkbox).not_to be_checked
    end
  end
end
