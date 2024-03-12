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
end
