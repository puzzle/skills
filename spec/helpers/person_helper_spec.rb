require 'rails_helper'

ptime_base_test_url = "www.ptime.example.com"
ptime_api_test_username = "test username"
ptime_api_test_password = "test password"
ENV["PTIME_BASE_URL"] = ptime_base_test_url
ENV["PTIME_API_USERNAME"] = ptime_api_test_username
ENV["PTIME_API_PASSWORD"] = ptime_api_test_password

RSpec.describe PersonHelper, type: :helper do
  employees_json = {
    'data' => [
      {
        'id' => 33,
        'type' => 'employee',
        'attributes' => {
          'shortname' => 'LSM',
          'firstname' => 'Longmax',
          'lastname' => 'Smith',
          'email' => 'longmax@example.com',
          'marital_status' => 'single',
          'nationalities' => ['ZW'],
          'graduation' => 'BSc in Architecture',
          'department_shortname' => 'SYS',
          'employment_roles' => []
        }
      },
      {
        'id' => 21,
        'type' => 'employee',
        'attributes' => {
          'shortname' => 'AMA',
          'firstname' => 'Alice',
          'lastname' => 'Mante',
          'full_name' => 'Alice Mante',
          'email' => 'alice@example.com',
          'marital_status' => 'single',
          'nationalities' => ['AU'],
          'graduation' => 'MSc in writing',
          'department_shortname' => 'SYS',
          'employment_roles' => [],
          'is_employed' => false,
          'birthdate' => '01.04.2001',
          'location' => 'Bern'
        }
      },
      {
        'id' => 45,
        'type' => 'employee',
        'attributes' => {
          'shortname' => 'CFO',
          'firstname' => 'Charlie',
          'lastname' => 'Ford',
          'email' => 'charlie@example.com',
          'marital_status' => 'married',
          'nationalities' => ['GB'],
          'graduation' => 'MSc in networking',
          'department_shortname' => 'SYS',
          'employment_roles' => []
        }
      }
    ]
  }.to_json

  describe '#fetch_ptime_or_skills_data' do
    it 'should send request to ptime api' do
      stub_request(:get, "http://#{ptime_base_test_url}/api/v1/employees?per_page=1000").
      to_return(body: employees_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                    .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])
      fetch_ptime_or_skills_data
    end

    it 'should return people from skills database if last request was right now' do
      ENV['LAST_PTIME_API_REQUEST'] = DateTime.current.to_s
      skills_people = fetch_ptime_or_skills_data
      expect(skills_people).to eq(Person.all)
    end
  end

  describe '#build_dropdown_data' do
    it 'should build correct dropdown data' do
      longmax = people(:longmax)
      alice = people(:alice)
      charlie = people(:charlie)

      longmax.update!(ptime_employee_id: 33)
      alice.update!(ptime_employee_id: 21)
      charlie.update!(ptime_employee_id: 45)

      parsed_employees = JSON.parse(employees_json)
      dropdown_data = build_dropdown_data(parsed_employees['data'], Person.all.pluck(:ptime_employee_id))

      expect(dropdown_data[0][:id]).to eq(longmax.id)
      expect(dropdown_data[0][:ptime_employee_id]).to eq(longmax.ptime_employee_id)
      expect(dropdown_data[0][:name]).to eq("Longmax Smith")
      expect(dropdown_data[0][:already_exists]).to be(true)

      expect(dropdown_data[1][:id]).to eq(alice.id)
      expect(dropdown_data[1][:ptime_employee_id]).to eq(alice.ptime_employee_id)
      expect(dropdown_data[1][:name]).to eq("Alice Mante")
      expect(dropdown_data[1][:already_exists]).to be(true)

      expect(dropdown_data[2][:id]).to eq(charlie.id)
      expect(dropdown_data[2][:ptime_employee_id]).to eq(charlie.ptime_employee_id)
      expect(dropdown_data[2][:name]).to eq("Charlie Ford")
      expect(dropdown_data[2][:already_exists]).to be(true)
    end
  end
end