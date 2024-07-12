require 'rails_helper'

ptime_base_test_url = "www.ptime.example.com"
ptime_api_test_username = "test username"
ptime_api_test_password = "test password"
ENV["PTIME_BASE_URL"] = ptime_base_test_url
ENV["PTIME_API_USERNAME"] = ptime_api_test_username
ENV["PTIME_API_PASSWORD"] = ptime_api_test_password

describe Ptime::Client do
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

    it 'should be able to fetch employee data' do
        stub_request(:get, "#{ptime_base_test_url}/api/v1/employees").
          to_return(body: employees_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                       .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

        fetched_employees = Ptime::Client.new.request(:get, "employees")
        expect(fetched_employees).to eq(JSON.parse(employees_json))
    end
end
