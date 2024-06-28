require 'rails_helper'

ptime_base_test_url = "www.ptime.example.com"
ptime_api_test_username = "test username"
ptime_api_test_password = "test password"
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
          'marital_status': 'single',
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
          'marital_status': 'single',
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
          'marital_status': 'married',
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

  before(:each) do
    ENV["PTIME_BASE_URL"] = ptime_base_test_url
  end

  it 'should update the data of existing people after mapping' do
    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: employees_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                               .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run(should_map: true)

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

  it 'should create new person when person does not exist' do
    new_employee = {
      'data': [
        {
          'id': 33,
          'type': 'employee',
          'attributes': {
            'shortname': 'PFI',
            'firstname': 'Peterson',
            'lastname': 'Findus',
            'email': 'peterson@example.com',
            'marital_status': 'single',
            'nationalities': [
              'ZW'
            ],
            'graduation': 'Cat caretaker',
            'department_shortname': 'CAT',
            'employment_roles': []
          }
        }
      ]
    }

    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: new_employee.to_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                               .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    Ptime::AssignEmployeeIds.new.run(should_map: true)
    Ptime::UpdatePeopleData.new.run

    new_employee_attributes = new_employee[:data].first[:attributes]
    new_employee_name = "#{new_employee_attributes[:firstname]} #{new_employee_attributes[:lastname]}"
    created_person = Person.find_by(name: new_employee_name)
    expect(created_person).not_to be_nil
    expect(created_person.ptime_employee_id).to eq(new_employee[:data].first[:id])
    expect(created_person.shortname).to eq(new_employee_attributes[:shortname])
    expect(created_person.name).to eq(new_employee_name)
    expect(created_person.email).to eq(new_employee_attributes[:email])
    expect(created_person.marital_status).to eq(new_employee_attributes[:marital_status])
    expect(created_person.title).to eq(new_employee_attributes[:graduation])
    expect(created_person.company).to eq(Company.first)
    expect(created_person.birthdate).to eq('1.1.2000')
    expect(created_person.location).to eq('Bern')
    expect(created_person.nationality).to eq('CH')
  end
end