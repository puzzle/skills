require 'rails_helper'

describe 'Manual PuzzleTime sync', type: :feature, js: true do
  let(:longmax) { people(:longmax) }
  let(:bob) { people(:bob) }

  before(:each) do
    enable_ptime_sync
    longmax.update!(ptime_employee_id: 33, ptime_data_provider: 'Firma', company: Company.find_by(name: 'Ex-Mitarbeiter'))
    bob.update!(ptime_employee_id: 23, ptime_data_provider: 'Partner')

    sign_in auth_users(:admin), scope: :auth_user
    visit admin_manual_ptime_sync_index_path
  end

  it 'should successfully run manual ptime sync method and show flash' do
    click_button('Personen manuell aktualisieren')
    expect(page).to have_content('Die Daten aller Personen wurden erfolgreich aktualisiert')

    longmax_attributes = ptime_company_employee_data.first[:attributes]
    bob_attributes = ptime_partner_employee_data.first[:attributes]

    expect(longmax.reload.name).to eql(employee_full_name(longmax_attributes))
    expect(bob.reload.name).to eql(employee_full_name(bob_attributes))
  end

  it 'should show flash when employees have unexpected values' do
    longmax_attributes, bob_attributes = stub_invalid_ptime_response

    click_button('Personen manuell aktualisieren')
    expect(page).to have_content("Bei der Aktualisierung von #{employee_full_name(longmax_attributes)} vom Provider Firma und #{employee_full_name(bob_attributes)}
                                  vom Provider Partner ist etwas schiefgelaufen. Versuche es erneut und überprüfe allenfalls die Daten im PuzzleTime.".squish)

    expect(longmax.reload.name).to eql('Longmax Smith')
  end

  it 'should show flash when something goes wrong while fetching data in client' do
    stub_ptime_request(*ptime_company_request_data.values, ptime_company_employee_data.to_json, "employees?per_page=1000", 404)

    click_button('Personen manuell aktualisieren')
    expect(page).to have_content('Etwas ist schiefgelaufen, als versucht wurde die Daten aus dem PuzzleTime zu fetchen. Bitte versuche es erneut und kontaktiere allenfalls den Support.')
  end
end