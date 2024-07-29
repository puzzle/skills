require 'rails_helper'

describe Ptime::PeopleEmployees do
  ptime_base_test_url = "www.ptime.example.com"
  ptime_api_test_username = "test username"
  ptime_api_test_password = "test password"
  before(:each) do
    ENV["PTIME_BASE_URL"] = ptime_base_test_url
    ENV["PTIME_API_USERNAME"] = ptime_api_test_username
    ENV["PTIME_API_PASSWORD"] = ptime_api_test_password
  end

  it 'should raise error when no ptime_employee_id is passed to new action' do
    expect{ Ptime::PeopleEmployees.new.create_person(nil) }.to raise_error(RuntimeError, 'No ptime_employee_id provided')
  end

  it 'should return person if it has the given ptime_employee_id' do
    person_wally = people(:wally)
    person_wally.ptime_employee_id = 123
    person_wally.save!

    new_person = Ptime::PeopleEmployees.new.create_person(person_wally.ptime_employee_id)
    expect(person_wally.attributes.except(*%w[created_at updated_at])).to eql(new_person.attributes.except(*%w[created_at updated_at]))
  end

  it 'should raise error when person is not found in ptime api' do
    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees/50").
      to_return(headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 404)
                                                                    .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    person_wally = people(:wally)
    person_wally.ptime_employee_id = 50
    person_wally.save!
    expect{ Ptime::PeopleEmployees.new.update_person_data(person_wally) }.to raise_error(RuntimeError, 'Ptime_employee with ptime_employee_id 50 not found')
  end
end