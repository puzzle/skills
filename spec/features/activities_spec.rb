require 'rails_helper'

describe 'Educations', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  describe 'Crud actions' do
    it 'shows all' do
      within('turbo-frame#activity') do
        person.activities.each do |activity|
          expect(page).to have_content(activity.role)
          expect(page).to have_content(activity.description)
        end
      end
    end

    it 'creates and saves new activity' do
      role = 'Pressure-washer dealer'
      description = 'Deals with pressure-washers'

      click_link(href: new_person_activity_path(person))

      within('turbo-frame#new_activity') do
        select '2024', from: 'activity_year_from'
        fill_in 'activity_role', with: role
        fill_in 'activity_description', with: description
        click_default_submit
      end


      expect(page).to have_content(role)
      expect(page).to have_content(description)
    end

    it 'updates activity' do
      updated_description = 'I am an updated description'

      activity = person.activities.first
      within("turbo-frame#activity_#{activity.id}") do
        find("[href=\"#{edit_person_activity_path(person, activity)}\"]").all("*").first.click
        fill_in 'activity_description', with: updated_description
        click_default_submit
      end
      expect(page).to have_content(updated_description)
    end

    it 'cancels without saving' do
      activity = person.activities.first
      old_description = activity.description
      updated_description = 'I like long descriptions'

      within("turbo-frame#activity_#{activity.id}") do
        find("[href=\"#{edit_person_activity_path(person, activity)}\"]").all("*").first.click
        fill_in 'activity_description', with: updated_description
        find('a', text: 'Abbrechen').click
      end
      expect(page).to have_content(old_description)
    end
  end

  describe 'Error handling' do
    it 'create new activity without role' do
      click_link(href: new_person_activity_path(person))

      within('turbo-frame#new_activity') do
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: "Rolle muss ausgefüllt werden")
    end

    it 'Update entry and clear role' do
      activity = person.activities.first
      within("turbo-frame#activity_#{activity.id}") do
        find("[href=\"#{edit_person_activity_path(person, activity)}\"]").all("*").first.click
        fill_in 'activity_role', with: ""
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: "Rolle muss ausgefüllt werden")
    end
  end

  def click_default_submit
    find("button[type='submit'][name='save']").click
  end

  def click_save_and_new_submit
    find("button[type='submit'][name='render_new_after_save']").click
  end
end