require 'rails_helper'

describe 'People management' do
  let(:bob) { people(:bob) }
  let(:alice) { people(:alice) }

  describe 'Not synced profiles' do
    before(:each) do
      sign_in auth_users(:conf_admin), scope: :auth_user
      enable_ptime_sync

      bob.update!(ptime_employee_id: nil, ptime_data_provider: nil)
      alice.update!(ptime_employee_id: nil, ptime_data_provider: nil)
    end

    it 'should show people when ptime sync is enabled and people not synced' do
      visit admin_people_management_path(people: 'not_synced')

      within page.all('table')[0] do
        expect(page).to have_content(bob.name)
        expect(page).to have_content(alice.name)
        Person.where.not(name: [bob.name, alice.name]).each do |person|
          expect(page).to have_content(person.name)
        end
      end
    end

    it 'should not show people when ptime sync is enabled and people is synced' do
      bob.update!(ptime_employee_id: 10, ptime_data_provider: 'A cool provider')
      alice.update!(ptime_employee_id: 11, ptime_data_provider: 'Another cool provider')

      visit admin_people_management_path(people: 'not_synced')

      within page.all('table')[0] do
        expect(page).not_to have_content(bob.name)
        expect(page).not_to have_content(alice.name)
        Person.where.not(name: [bob.name, alice.name]).each do |person|
          expect(page).to have_content(person.name)
        end
      end
    end

    it 'should not show people when ptime sync is disabled and people not synced' do
      disable_ptime_sync

      visit admin_people_management_path(people: 'not_synced')

      expect(page).to have_content('Momentan gibt es nichts zu bereinigen')
    end

    it 'should not show button for not synced people when ptime sync is disabled' do
      disable_ptime_sync

      visit admin_index_path

      expect(page).not_to have_content('Nicht synchronisierte Profile löschen')
    end

    it 'should delete person after confirming', js: true do
      visit admin_people_management_path(people: 'not_synced')

      expect(Person.find_by(name: bob.name)).to be_present

      within "#person_#{bob.id}" do
        accept_confirm("Willst du diesen Eintrag wirklich löschen?") do
          click_button('Löschen')
        end
      end

      expect(page).to have_content("Bob Anderson wurde erfolgreich gelöscht.")

      expect(Person.find_by(name: bob.name)).to be_nil
    end

    it 'should show info message when there is nothing to clean up', js: true do
      employed_company = Company.find_by(name: 'Firma')
      Person.all.update!(company: employed_company, ptime_employee_id: 1, ptime_data_provider: 'Test provider')

      visit admin_people_management_path(people: 'not_synced')

      expect(page).to have_content('Momentan gibt es nichts zu bereinigen')
    end
  end

  describe 'unemployed people' do
    before(:each) do
      sign_in auth_users(:conf_admin), scope: :auth_user

      unemployed_company = companies('ex-mitarbeiter')
      bob.update!(company: unemployed_company)
      alice.update!(company: unemployed_company)
    end

    it 'should show unemployed people' do
      visit admin_people_management_path(people: 'unemployed')

      within page.all('table')[0] do
        expect(page).to have_content(bob.name)
        expect(page).to have_content(alice.name)
      end
    end

    it 'should delete person after confirming', js: true do
      visit admin_people_management_path(people: 'unemployed')

      within "#person_#{bob.id}" do
        accept_confirm("Willst du diesen Eintrag wirklich löschen?") do
          click_button('Löschen')
        end
      end

      expect(page).to have_content("Bob Anderson wurde erfolgreich gelöscht.")

      expect(Person.find_by(name: bob.name)).to be_nil
    end

    it 'should show info message when there is nothing to clean up' do
      employed_company = Company.find_by(name: 'Firma')
      Person.all.update!(company: employed_company, ptime_employee_id: 1, ptime_data_provider: 'Test provider')

      visit admin_people_management_path(people: 'unemployed')

      expect(page).to have_content('Momentan gibt es nichts zu bereinigen')
    end
  end
end