require 'rails_helper'

describe 'People management', type: :feature, js: true do
  let(:bob) { people(:bob) }
  let(:alice) { people(:alice) }

  before(:each) do
    sign_in auth_users(:admin), scope: :auth_user
    enable_ptime_sync

    unemployed_company = companies('ex-mitarbeiter')
    bob.update!(company: unemployed_company, ptime_employee_id: 10, ptime_data_provider: 'A cool provider')
    alice.update!(company: unemployed_company, ptime_employee_id: 11, ptime_data_provider: 'Another cool provider')
  end

  it 'should show ex-members and profiles that are not synced by PuzzleTime' do
    visit admin_people_management_path

    within page.all('table')[0] do
      expect(page).to have_content(bob.name)
      expect(page).to have_content(alice.name)
    end

    within page.all('table')[1] do
      expect(page).not_to have_content(bob.name)
      expect(page).not_to have_content(alice.name)
      Person.where.not(name: [bob.name, alice.name]).each do |person|
        expect(page).to have_content(person.name)
      end
    end
  end

  it 'should delete person after confirming' do
    visit admin_people_management_path

    within "#unemployed-people-person_#{bob.id}" do
      accept_confirm("Willst du diesen Eintrag wirklich löschen?") do
        click_button('Löschen')
      end
    end

    within page.all('table')[0] do
      expect(page).not_to have_content(bob.name)
    end

    expect(Person.find_by(name: bob.name)).to be_nil
  end

  it 'should show info message when there is nothing to clean up' do
    employed_company = Company.find_by(name: 'Firma')
    Person.all.update!(company: employed_company, ptime_employee_id: 1, ptime_data_provider: 'Test provider')

    visit admin_people_management_path

    expect(page).to have_content('Momentan gibt es nichts zu bereinigen')
  end
end