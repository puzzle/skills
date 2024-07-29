require 'rails_helper'

describe Ptime::UpdatePersonData do
  ptime_base_test_url = "www.ptime.example.com"
  ptime_api_test_username = "test username"
  ptime_api_test_password = "test password"
  before(:each) do
    ENV["PTIME_BASE_URL"] = ptime_base_test_url
    ENV["PTIME_API_USERNAME"] = ptime_api_test_username
    ENV["PTIME_API_PASSWORD"] = ptime_api_test_password
  end

  describe 'Update or create person', type: :feature, js: true do
    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'should update person when visited' do
      updated_wally = {
        'data': {
          'id': 50,
          'type': 'employee',
          'attributes': {
            'shortname': 'CAL',
            'firstname': 'Changed Wally',
            'lastname': 'Allround',
            'full_name': 'Changed Wally Allround',
            'email': 'changedwally@example.com',
            'marital_status': 'single',
            'nationalities': %w[DE DK],
            'graduation': 'Quarter-Stack Developer',
            'department_shortname': 'SYS',
            'employment_roles': [],
            'is_employed': false,
            'birthdate': '1.1.2000',
            'location': 'Basel',
          }}
        }


      stub_request(:get, "#{ptime_base_test_url}/api/v1/employees/50").
        to_return(body: updated_wally.to_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                                 .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

      Company.create!(name: "Ex-Mitarbeiter")
      person_wally = people(:wally)
      person_wally.ptime_employee_id = 50
      person_wally.save!

      expect(person_wally.name).to eq('Wally Allround')
      expect(person_wally.email).to eq('wally@example.com')
      visit person_path(person_wally)
      person_wally.reload
      expect(person_wally.name).to eq('Changed Wally Allround')
      expect(person_wally.shortname).to eq('CAL')
      expect(person_wally.email).to eq('changedwally@example.com')
      expect(person_wally.marital_status).to eq('single')
      expect(person_wally.title).to eq('Quarter-Stack Developer')
      expect(person_wally.birthdate).to eq('1.1.2000')
      expect(person_wally.location).to eq('Basel')
      expect(person_wally.nationality).to eq('DE')
      expect(person_wally.nationality2).to eq('DK')
    end

    it 'should create person when visited' do
      updated_wally = {
        'data': {
          'id': 50,
          'type': 'employee',
          'attributes': {
            'shortname': 'CAL',
            'firstname': 'Changed Wally',
            'lastname': 'Allround',
            'full_name': 'Changed Wally Allround',
            'email': 'changedwally@example.com',
            'marital_status': 'single',
            'nationalities': %w[DE EG],
            'graduation': 'Quarter-Stack Developer',
            'department_shortname': 'SYS',
            'employment_roles': [],
            'is_employed': true,
            'birthdate': '1.1.2000',
            'location': 'Basel',
          }}
      }

      stub_request(:get, "#{ptime_base_test_url}/api/v1/employees/50").
        to_return(body: updated_wally.to_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                      .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])
      Company.create!(name: "Ex-Mitarbeiter")

      person_wally = people(:wally)
      person_wally.destroy!
      expect(Person.find_by(name: "Wally Allround")).to be_nil
      visit new_person_path(ptime_employee_id: 50)
      new_wally = Person.find_by(name: "Changed Wally Allround")
      expect(new_wally.name).to eq('Changed Wally Allround')
      expect(new_wally.shortname).to eq('CAL')
      expect(new_wally.email).to eq('changedwally@example.com')
      expect(new_wally.marital_status).to eq('single')
      expect(new_wally.title).to eq('Quarter-Stack Developer')
      expect(new_wally.birthdate).to eq('1.1.2000')
      expect(new_wally.location).to eq('Basel')
      expect(new_wally.nationality).to eq('DE')
      expect(new_wally.nationality2).to eq('EG')
    end
  end
end