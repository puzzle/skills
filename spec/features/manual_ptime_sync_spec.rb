require 'rails_helper'

describe 'Manual PuzzleTime sync', type: :feature, js: true do
  let(:longmax) { people(:longmax) }

  before(:each) do
    sign_in auth_users(:admin), scope: :auth_user
    enable_ptime_sync

    longmax.update!(ptime_employee_id: 33)
    longmax.update!(company: Company.find_by(name: 'Ex-Mitarbeiter'))
  end

  it 'should successfully run manual ptime sync method and show flash' do
    visit admin_manual_ptime_sync_index_path
    click_button('Personen manuell aktualisieren')

    expect(page).to have_content('Die Daten aller Personen wurden erfolgreich aktualisiert')

    longmax_attributes = ptime_employees_data.first[:attributes]
    expect(longmax.reload.name).to eql(employee_full_name(longmax_attributes))
  end

  it 'should show flash when employees have unexpected values' do
    people_employees_json = ptime_employees
    longmax_attributes = people_employees_json[:data].first[:attributes]
    longmax_attributes[:email] = ''

    stub_ptime_request(people_employees_json.to_json)

    visit admin_manual_ptime_sync_index_path
    click_button('Personen manuell aktualisieren')

    expect(page).to have_content("Bei der Aktualisierung von #{employee_full_name(longmax_attributes)} ist etwas schiefgelaufen. Versuche es erneut und überprüfe allenfalls die Daten im PuzzleTime.")

    expect(longmax.reload.name).to eql('Longmax Smith')
  end
end