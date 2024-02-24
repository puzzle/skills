require 'rails_helper'

describe :people do
  describe 'People Search', type: :feature, js: true do

    it 'can edit skill in table ' do
      visit skills_path

      # list = Skill.pluck(:title).sort
      # within 'section[data-controller="dropdown"]' do
      #   expect(page).to have_select('person_id', options: list, selected: list.first)
      # end
    end

    it 'redirects to the selected person on change' do
      visit people_path
      bob = skills(:bash)

      within 'section[data-controller="dropdown"]' do
        select bob.name, from: 'person_id'
      end

      expect(page).to have_current_path(person_path(bob))
      expect(page).to have_select('person_id', selected: bob.name)
    end
  end
end
