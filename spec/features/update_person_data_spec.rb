require 'rails_helper'

ptime_base_test_url = "www.ptime.example.com"
ptime_api_test_username = "test username"
ptime_api_test_password = "test password"
ENV["PTIME_BASE_URL"] = ptime_base_test_url
ENV["PTIME_API_USERNAME"] = ptime_api_test_username
ENV["PTIME_API_PASSWORD"] = ptime_api_test_password

employees = {
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
    {
      'id': 50,
      'type': 'employee',
      'attributes': {
        'shortname': 'WAL',
        'firstname': 'Wally',
        'lastname': 'Allround',
        'email': 'wally@example.com',
        'marital_status': 'married',
        'nationalities': [
          'US'
        ],
        'graduation': 'Full-Stack Developer',
        'department_shortname': 'SYS',
        'employment_roles': []
      }
    },
  ]
}

describe Ptime::UpdatePersonData do
  it 'should update person when visited' do
    updated_wally = {
      'id': 50,
      'type': 'employee',
      'attributes': {
        'shortname': 'CAL',
        'firstname': 'Changed Wally',
        'lastname': 'Allround',
        'fullname': 'Changed Wally Allround',
        'email': 'changedwally@example.com',
        'marital_status': 'single',
        'nationalities': [
          'US'
        ],
        'graduation': 'Quarter-Stack Developer',
        'department_shortname': 'SYS',
        'employment_roles': [],
        is_employed: false,
        birthdate: '1.1.2000',
        location: 'Bern',
        nationality: 'CH'
    }}

    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: updated_wally.to_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                               .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    person_wally = people(:wally)
    expect(person_wally.name).to eq('Wally Allround')
    expect(person_wally.shortname).to eq('WAL')
    visit person_path(person_wally)
    person_wally.reload
    expect(person_wally.name).to eq('Changed Wally Allround')
    expect(person_wally.shortname).to eq('CAL')
    expect(person_wally.email).to eq('changedwally@example.com')
    expect(person_wally.marital_status).to eq('single')
    expect(person_wally.title).to eq('Quarter-Stack Developer')
    expect(person_wally.birthdate).to eq('1.1.2000')
    expect(person_wally.location).to eq('Bern')
    expect(person_wally.nationality).to eq('CH')
  end
end