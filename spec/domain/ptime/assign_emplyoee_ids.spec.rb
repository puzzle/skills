require 'rails_helper'

ptime_base_test_url = "www.ptime.example.com"
ptime_api_test_username = "test username"
ptime_api_test_password = "test password"
ENV["PTIME_BASE_URL"] = ptime_base_test_url
ENV["PTIME_API_USERNAME"] = ptime_api_test_username
ENV["PTIME_API_PASSWORD"] = ptime_api_test_password

describe Ptime::AssignEmployeeIds do
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

  it 'should map people with the correct puzzletime id' do
    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: employees_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                 .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run

    expect(person_longmax.reload.ptime_employee_id).to eq(33)
    expect(person_alice.reload.ptime_employee_id).to eq(21)
    expect(person_charlie.reload.ptime_employee_id).to eq(45)
  end

  it 'should not match people that are not found' do
    parsed_employees_json = JSON.parse(employees_json)
    parsed_employees_json['data'].first["attributes"]["firstname"] = "Rochus"
    parsed_employees_json['data'].second["attributes"]["firstname"] = "Melchior"
    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: parsed_employees_json.to_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                               .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run

    expect(person_longmax.reload.ptime_employee_id).to be_nil
    expect(person_alice.reload.ptime_employee_id).to be_nil
    expect(person_charlie.reload.ptime_employee_id).to eq(45)
  end

  it 'should not match people that are ambiguous' do
    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: employees_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                 .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])
    
    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    person_charlie.name = "Alice Mante"
    person_charlie.email = "alice@example.com"
    person_charlie.save!

    Ptime::AssignEmployeeIds.new.run

    expect(person_longmax.reload.ptime_employee_id).to eq(33)
    expect(person_alice.reload.ptime_employee_id).to be_nil
    expect(person_charlie.reload.ptime_employee_id).to be_nil
  end
end