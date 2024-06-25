require 'rails_helper'

ENV["PTIME_BASE_URL"] = "www.api.com"
ENV["PTIME_API_USERNAME"] = "test username"
ENV["PTIME_API_PASSWORD"] = "test password"

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
            'email': 'longmax@smith.com',
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
            'email': 'alice@mante.com',
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
            'email': 'charlie@ford.com',
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

    before(:each) do
        stub_request(:get, "#{ENV["PTIME_BASE_URL"]}/api/v1/employees").
            to_return(body: employees_json, headers: { 'pagination-total-count': 200, 'pagination-per-page': 20, 'pagination-current-page': 5, 'pagination-total-pages': 10, 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
    end

    it 'should be able to fetch employee data' do
        fetched_employees = Ptime::Client.new.get("employees")
        expect(fetched_employees).to eq(JSON.parse(employees_json))
    end
end
