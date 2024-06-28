require 'rails_helper'

ptime_base_test_url = "www.ptime.example.com"
ptime_api_test_username = "test username"
ptime_api_test_password = "test password"
ENV["PTIME_BASE_URL"] = ptime_base_test_url
ENV["PTIME_API_USERNAME"] = ptime_api_test_username
ENV["PTIME_API_PASSWORD"] = ptime_api_test_password

describe Ptime::UpdatePeopleData do
  employees_json = {
    'data': [
      {
        'id': 33,
        'type': 'employee',
        'attributes': {
          'shortname': 'LSM',
          'firstname': 'Longmax',
          'lastname': 'Smith',
          'email': 'longmax@example.com',
          'single': 'single',
          'nationalities': [
            'ZW'
          ],
          'graduation': 'BSc in Architecture',
          'department_shortname': 'SYS',
          'employment_roles': []
        }
      },
      {
        'id': 21,
        'type': 'employee',
        'attributes': {
          'shortname': 'AMA',
          'firstname': 'Alice',
          'lastname': 'Mante',
          'email': 'alice@example.com',
          'single': 'single',
          'nationalities': [
            'AU'
          ],
          'graduation': 'MSc in writing',
          'department_shortname': 'SYS',
          'employment_roles': []
        }
      },
      {
        'id': 45,
        'type': 'employee',
        'attributes': {
          'shortname': 'CFO',
          'firstname': 'Charlie',
          'lastname': 'Ford',
          'email': 'charlie@example.com',
          'single': 'married',
          'nationalities': [
            'GB'
          ],
          'graduation': 'MSc in networking',
          'department_shortname': 'SYS',
          'employment_roles': []
        }
      },
    ]
  }.to_json

  it 'should update the data of existing people after mapping' do
    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: employees_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                               .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run(should_map: true)

    person_longmax.reload
    person_alice.reload
    person_charlie.reload

    parsed_employees_json = JSON.parse(employees_json)
    parsed_employees_json['data'].first["attributes"]["email"] = "changedmax@example.com"
    parsed_employees_json['data'].second["attributes"]["graduation"] = "MSc in some other field"
    parsed_employees_json['data'].last["attributes"]["firstname"] = "Claudius"

    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: parsed_employees_json.to_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                               .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    Ptime::UpdatePeopleData.new.run

    expect(person_longmax.reload.email).to eq("changedmax@example.com")
    expect(person_alice.reload.title).to eq("MSc in some other field")
    expect(person_charlie.reload.name).to eq("Claudius Ford")
  end
end