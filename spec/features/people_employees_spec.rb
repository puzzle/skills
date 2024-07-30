require 'rails_helper'

describe Ptime::PeopleEmployees do
  describe 'Update or create person', type: :feature, js: true do
    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'should update person when visited' do
      stub_ptime_request(fixture_data("wally").to_json, "employees/50", 200)

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
      stub_ptime_request(fixture_data("wally").to_json, "employees/50", 200)

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
      expect(new_wally.nationality2).to eq('DK')
    end
  end
end