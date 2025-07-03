require 'rails_helper'

describe 'Contributions', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  describe 'Crud actions' do
    it 'displays all' do
      within('turbo-frame#contribution') do
        person.contributions.each do |contribution|
          expect(page).to have_content(contribution.title)
          expect(page).to have_content(contribution.reference)
        end
      end
    end

    it 'creates and saves new contribution' do
      title = 'Extended faker gem'
      reference = 'https://example.com'

      open_create_form(Contribution)

      within('turbo-frame#new_contribution') do
        select '2024', from: 'contribution_year_from'
        select 'Januar', from: 'contribution_month_from'
        fill_in 'contribution_title', with: title
        fill_in 'contribution_reference', with: reference
        click_default_submit
      end

      expect(page).to have_content(title)
      expect(page).to have_content(reference)
    end

    it 'creates new with save & new' do
      title = 'Extended faker gem'
      reference = 'https://example.com'

      open_create_form(Contribution)

      within('turbo-frame#new_contribution') do
        select '2024', from: 'contribution_year_from'
        select 'Januar', from: 'contribution_month_from'
        fill_in 'contribution_title', with: title
        fill_in 'contribution_reference', with: reference
        click_save_and_new_submit
      end

      expect(page).to have_content(title)
      expect(page).to have_content(reference)
      expect(page).to have_select('contribution_year_from', selected: "")
      expect(page).to have_select('contribution_month_from', selected: "-")
      expect(page).to have_field('contribution_title', with: "")
      expect(page).to have_field('contribution_reference', with: "")
    end

    it 'updates contribution' do
      updated_title = 'I am an updated title'
      contribution = person.contributions.first

      open_edit_form(contribution)

      within("turbo-frame#contribution_#{contribution.id}") do
        fill_in 'contribution_title', with: updated_title
        click_default_submit
      end
      expect(page).to have_content(updated_title)
    end

    it 'cancels without saving' do
      contribution = person.contributions.first
      old_description = contribution.reference
      updated_reference = 'Should not be saved!'

      open_edit_form(contribution)

      within("turbo-frame#contribution_#{contribution.id}") do
        fill_in 'contribution_reference', with: updated_reference
        find('a', text: 'Abbrechen').click
      end
      expect(page).to have_content(old_description)
    end

    it 'deletes contribution' do
      contribution = person.contributions.first
      title = contribution.title

      open_edit_form(contribution)

      within("turbo-frame#contribution_#{contribution.id}") do
        accept_confirm do
          click_link("Löschen")
        end
      end
      expect(page).not_to have_content(title)
    end

    it 'Update entry to not be displayed in the CV' do
      contribution = person.contributions.first
      open_edit_form(contribution)
      checkbox = find('#contribution_display_in_cv')
      within("turbo-frame#contribution_#{contribution.id}") do
        checkbox.click
        click_default_submit
        expect(find("img")[:src]).to have_content("no-file")
      end
      open_edit_form(contribution)
      expect(checkbox).not_to be_checked
    end
  end

  describe 'Error handling' do
    it 'create new contribution without title' do
      open_create_form(Contribution)

      within('turbo-frame#new_contribution') do
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: "Titel muss ausgefüllt werden")
    end

    it 'Update entry and clear title' do
      contribution = person.contributions.first
      open_edit_form(contribution)
      within("turbo-frame#contribution_#{contribution.id}") do
        fill_in 'contribution_title', with: ""
        click_default_submit
      end
      expect(page).to have_css(".alert.alert-danger", text: "Titel muss ausgefüllt werden")
    end
  end
end