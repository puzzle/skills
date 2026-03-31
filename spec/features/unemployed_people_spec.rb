require 'rails_helper'

describe 'unemployed people' do
  let(:bob) { people(:bob) }
  let(:alice) { people(:alice) }

  before(:each) do
    sign_in auth_users(:conf_admin), scope: :auth_user

    unemployed_company = companies('ex-mitarbeiter')
    bob.update!(company: unemployed_company)
    alice.update!(company: unemployed_company)
  end

  it 'should show unemployed people' do
    visit admin_unemployed_people_path

    within page.all('table')[0] do
      expect(page).to have_content(bob.name)
      expect(page).to have_content(alice.name)
    end
  end

  it 'should delete person after confirming', js: true do
    visit admin_unemployed_people_path

    within "#person_#{bob.id}" do
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

    visit admin_unemployed_people_path

    expect(page).to have_content('Momentan gibt es nichts zu bereinigen')
  end
end