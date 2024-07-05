require 'rails_helper'

ptime_base_test_url = "www.ptime.example.com"
ptime_api_test_username = "test username"
ptime_api_test_password = "test password"
ENV["PTIME_BASE_URL"] = ptime_base_test_url
ENV["PTIME_API_USERNAME"] = ptime_api_test_username
ENV["PTIME_API_PASSWORD"] = ptime_api_test_password

describe Ptime::UpdatePersonData do
  it 'should raise error when no ptime_employee_id is passed to new action' do
    expect{ Ptime::UpdatePersonData.new.create_person(nil) }.to raise_error(RuntimeError, 'No ptime_employee_id provided')
  end

  it 'should create default person if ptime_employee_id doesnt already exist' do
    default_person = Person.create(name: 'Default name', company: Company.first, birthdate: '1.1.1970',
                                    nationality: 'CH', location: 'Bern', title: 'Default title',
                                    email: 'default@example.com', ptime_employee_id: 123)

    new_person = Ptime::UpdatePersonData.new.create_person(123)
    expect(default_person.attributes.except(*%w[created_at updated_at])).to eql(new_person.attributes.except(*%w[created_at updated_at]))
  end

  it 'should return person if it has the given ptime_employee_id' do
    person_wally = people(:wally)
    person_wally.ptime_employee_id = 123
    person_wally.save!

    new_person = Ptime::UpdatePersonData.new.create_person(person_wally.ptime_employee_id)
    expect(person_wally.attributes.except(*%w[created_at updated_at])).to eql(new_person.attributes.except(*%w[created_at updated_at]))
  end

  it 'should raise error when person is not found in ptime api' do
    stub_request(:get, "#{ptime_base_test_url}/api/v1/employees/50").
      to_return(headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 404)
                                                                    .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

    person_wally = people(:wally)
    person_wally.ptime_employee_id = 50
    person_wally.save!

    expect{ Ptime::UpdatePersonData.new.update_person_data(person_wally) }.to raise_error(RuntimeError, 'Ptime_employee with id 50 not found')
  end
end