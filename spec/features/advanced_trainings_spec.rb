require 'rails_helper'

describe 'Advanced Trainings', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  describe 'Simple interactions' do
    it 'shows all' do
      within('turbo-frame#advanced_trainings_all') do
        expect(page).to have_content('2010 - 2012')
        expect(page).to have_content('course about how to clean')
      end
    end

    it 'Create new' do
      description = "new description"
      click_link(href: new_person_advanced_training_path(person))

      within('turbo-frame#new_advanced_training') do
        fill_in 'advanced_training_description', with: description
        find("button[type='submit']").click
      end

      expect(person.advanced_trainings.last.description).to eq(description)
    end

    it 'Update entry' do
      description = "updated description"

      at = person.advanced_trainings.first
      within("turbo-frame#advanced_training_#{at.id}") do
        find("[href=\"#{edit_person_advanced_training_path(person, at)}\"]").all("*").first.click
        fill_in 'advanced_training_description', with: description
        find("button[type='submit']").click
      end
      expect(person.advanced_trainings.last.description).to eq(description)
    end
  end

  describe 'Error handling' do

    it 'Create new without description' do
      click_link(href: new_person_advanced_training_path(person))

      within('turbo-frame#new_advanced_training') do
        find("button[type='submit']").click
      end
      expect(page).to have_css(".alert.alert-danger", text: "Description muss ausgefüllt werden")
    end

    it 'Update entry and clear description' do
      at = person.advanced_trainings.first
      within("turbo-frame#advanced_training_#{at.id}") do
        find("[href=\"#{edit_person_advanced_training_path(person, at)}\"]").all("*").first.click
        fill_in 'advanced_training_description', with: ""
        find("button[type='submit']").click
      end
      expect(page).to have_css(".alert.alert-danger", text: "Description muss ausgefüllt werden")
    end
  end
end
