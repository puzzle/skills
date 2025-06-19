require 'rails_helper'

describe :people do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
    visit root_path
  end

  describe 'CV-Export', type: :feature, js: true do
    it 'should display 2 export buttons' do
      visit person_path(people(:bob))

      expect(page.all('a', text: 'Export').count).to eql(1)
    end

    it 'should display range after switch was clicked' do
      visit person_path(people(:bob))
      page.all('a', text: 'Export').first.click

      expect(page).not_to have_field('levelValue')
      page.first('#skillsByLevel').click
      expect(page).to have_field('levelValue')
    end

    it 'should display correct label when range increased' do
      visit person_path(people(:bob))
      page.all('a', text: 'Export').first.click

      page.first('#skillsByLevel').click
      page.find('#levelValue').set(5)
      expect(page).to have_text('Expert')
    end

    it 'should display info message after downloading the cv' do
      visit person_path(people(:bob))
      page.all('a', text: 'Export').first.click
      click_button('Herunterladen')
      expect(page).to have_content('Achtung: bitte vor dem Versenden den CV in LibreOffice öffnen und das Inhaltsverzeichnis aktualisieren')
    end
  end
end
