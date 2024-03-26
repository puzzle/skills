require 'rails_helper'

describe 'Advanced Trainings', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  it 'shows all' do
    within('turbo-frame#advanced_trainings_all') do
      expect(page).to have_content('2010 - 2012')
      expect(page).to have_content('course about how to clean')
    end
  end

  it 'Create new' do
    click_link(href: new_person_advanced_training_path(person))

    within('turbo-frame#new_advanced_training') do
      fill_in 'advanced_training_description', with: 'new description'
      require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
      find("button[type='submit']").click
    end
  end

  it 'displays error messages when present' do
    at = person.advanced_trainings.first
    within("turbo-frame#advanced_training_#{at.id}") do
      find("[href=\"#{edit_person_advanced_training_path(person, at)}\"]").all("*").first.click
      fill_in 'advanced_training_description', with: 'test'
      find("button[type='submit']").click
    end
  end

  it 'redirects to the skills index when the cancel button is clicked' do
  end
end
