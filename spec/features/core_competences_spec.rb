require 'rails_helper'

describe "Core competences", type: :feature, js: true do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
    visit root_path
  end
  let(:alice) { people(:alice) }

  it 'should display core competences' do
    visit person_path(people(:bob))
    expect(page).to have_selector('.core-competence', count: 1)
    expect(page).to have_text('Software-Engineering')
    expect(page).to have_text('Rails')
  end

  it 'should display competence notes and edit link correctly' do
    visit person_path(alice)
    expect(page).to have_text("LaTex Puppet Bash", normalize_ws: true)
    expect(page).to have_selector('.icon-pencil')
  end

  it 'should update competence notes' do
    visit person_path(alice)
    click_link(href: competence_notes_person_path(alice))
    expect(page).to have_selector('.form-control')

    fill_in 'person_competence_notes', with: 'Hello World here'
    click_button "Aktualisieren"
    expect(page).to have_content('Hello World here')
  end

  it 'should not update competence notes when clicking cancel button' do
    visit person_path(alice)
    click_link(href: competence_notes_person_path(alice))
    expect(page).to have_selector('.form-control')

    fill_in 'person_competence_notes', with: 'Hello World here'
    click_link(text: "Abbrechen")
    expect(page).to have_text("LaTex Puppet Bash", normalize_ws: true)
  end

  it 'should display skill with same parent category in same row with divider' do
    visit person_path(alice)
    expect(page).to have_selector('.circle-divider')
    expect(page).to have_selector('.core-competence', count: 1,
                                  text: "Software-Engineering Rails ember", normalize_ws: true)
  end

  it 'Update core competence notes to not be displayed in the CV' do
    visit person_path(alice)
    click_link(href: competence_notes_person_path(alice))
    checkbox = find('#person_display_competence_notes_in_cv')
    checkbox.click
    click_button "Aktualisieren"
    within("#competence-notes") do
      expect(page).to have_css("img[src*='no-file']")
    end
    click_link(href: competence_notes_person_path(alice))
    expect(checkbox).not_to be_checked
  end
end
