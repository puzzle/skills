require 'rails_helper'

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
end