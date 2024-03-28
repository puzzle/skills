require 'rails_helper'

describe "Core competences" do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
    visit root_path
  end

  it 'should display core competences' do
    visit person_path(people(:bob))
    expect(page).to have_selector('.core-competence', count: 1)
    expect(page).to have_text('Software-Engineering')
    expect(page).to have_text('Rails')
  end

  it 'should display competence notes and edit link correctly' do
    visit person_path(people(:alice))
    expect(page).to have_text('LaTex\n Puppet\n Bash')
    expect(page).to have_selector('#edit-link')
  end

  it 'should update competence notes' do
    visit person_path(people(:alice))
    page.find('#edit-link').click
    expect(page).to have_selector('.form-control')

    fill_in 'person_competence_notes', with: 'Hello World here'
    page.find('#save').click
    expect(page).to have_text('Hello World here')
  end

  it 'should not update competence notes when clicking cancel button' do
    visit person_path(people(:alice))
    page.find('#edit-link').click
    expect(page).to have_selector('.form-control')

    fill_in 'person_competence_notes', with: 'Hello World here'
    page.find('#cancel').click
    expect(page).to have_text('LaTex\n Puppet\n Bash')
  end

  it 'should display skill with same parent category in same row with divider' do
    visit person_path(people(:alice))
    expect(page).to have_selector('.circle-divider')
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    expect(page).to have_selector('.core-competence', text: "Software-Engineering\nRails\nember")
  end
end
