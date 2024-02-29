require 'rails_helper'

describe :people do
  describe 'People Search', type: :feature, js: true do

    before(:each) do
      bob = people(:bob)
      login_as(bob, scope: :person)
    end

    it 'displays people in alphabetical order in select' do
      visit people_path
      list = Person.pluck(:name).sort
      within 'section[data-controller="dropdown"]' do
        expect(page).to have_select('person_id', options: list, selected: list.first)
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
  end
end
