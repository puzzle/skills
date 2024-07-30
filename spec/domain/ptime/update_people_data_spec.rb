require 'rails_helper'

describe Ptime::UpdatePeopleData do
  it 'should update the data of existing people after mapping' do
    employees = fixture_data "updating_ptime_employees"

    stub_ptime_request(employees.to_json)

    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)
    person_wally = people(:wally)

    Ptime::AssignEmployeeIds.new.run(should_map: true)
    employees[:data].first[:attributes][:email] = "changedmax@example.com"
    employees[:data].second[:attributes][:graduation] = "MSc in some other field"
    employees[:data].third[:attributes][:firstname] = "Claudius"
    employees[:data].fourth[:attributes][:marital_status] = "single"


    stub_ptime_request(employees.to_json)

    Ptime::UpdatePeopleData.new.run

    expect(person_longmax.reload.email).to eq("changedmax@example.com")
    expect(person_alice.reload.title).to eq("MSc in some other field")
    expect(person_charlie.reload.name).to eq("Claudius Ford")
    expect(person_wally.reload.marital_status).to eq("single")
  end

  it 'should create new person when person does not exist' do
    new_employee =  fixture_data "new_ptime_employee"
    new_employee_data = new_employee[:data]
    stub_ptime_request(new_employee.to_json)

    Ptime::AssignEmployeeIds.new.run(should_map: true)
    Ptime::UpdatePeopleData.new.run

    new_employee_attributes = new_employee_data.first[:attributes]
    new_employee_name = "#{new_employee_attributes[:firstname]} #{new_employee_attributes[:lastname]}"
    created_person = Person.find_by(name: new_employee_name)
    expect(created_person).not_to be_nil
    expect(created_person.ptime_employee_id).to eq(new_employee_data.first[:id])
    expect(created_person.shortname).to eq(new_employee_attributes[:shortname])
    expect(created_person.name).to eq(new_employee_name)
    expect(created_person.email).to eq(new_employee_attributes[:email])
    expect(created_person.marital_status).to eq(new_employee_attributes[:marital_status])
    expect(created_person.title).to eq(new_employee_attributes[:graduation])
    expect(created_person.company).to eq(Company.first)
    expect(created_person.birthdate).to eq('1.1.2000')
    expect(created_person.location).to eq('Bern')
    expect(created_person.nationality).to eq('CH')
  end
end
