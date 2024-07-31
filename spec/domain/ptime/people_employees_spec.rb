require 'rails_helper'

describe Ptime::PeopleEmployees do
  it 'should raise error when no ptime_employee_id is passed to new action' do
    expect{ Ptime::PeopleEmployees.new.find_or_create(nil) }.to raise_error(RuntimeError, 'No ptime_employee_id provided')
  end

  it 'should return person if it has the given ptime_employee_id' do
    person_wally = people(:wally)
    person_wally.ptime_employee_id = 123
    person_wally.save!

    new_person = Ptime::PeopleEmployees.new.find_or_create(person_wally.ptime_employee_id)
    expect(person_wally.attributes.except(*%w[created_at updated_at])).to eql(new_person.attributes.except(*%w[created_at updated_at]))
  end

  xit 'should raise error when person is not found in ptime api' do
    stub_ptime_request('', "employees/50", 404)

    person_wally = people(:wally)
    person_wally.ptime_employee_id = 50
    person_wally.save!
    expect{ Ptime::PeopleEmployees.new.update_person_data(person_wally) }.to raise_error(RuntimeError, 'Ptime_employee with ptime_employee_id 50 not found')
  end
end