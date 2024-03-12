require 'rails_helper'

describe :people do
  describe 'CV-Export', type: :feature, js: true do
    it 'should display range after switch was clicked' do
      visit person_path(people(:bob))
      page.find('a', text: 'Export').click

      expect(page).not_to have_field('levelValue')
      page.first('#skillsByLevel').click
      expect(page).to have_field('levelValue')
    end

    it 'should display correct label when range increased' do
      visit person_path(people(:bob))
      page.find('a', text: 'Export').click

      page.first('#skillsByLevel').click
      page.find('#levelValue').set(5)
      expect(page).to have_text('Expert')
    end
  end
end
