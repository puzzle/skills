require 'rails_helper'

describe Ptime::AssignEmployeeIds do

  before(:each) do
    enable_ptime_sync
  end

  it 'should map people with the correct puzzletime id' do
    person_bob = people(:bob)
    person_longmax = people(:longmax)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run(should_map: true)

    expect(person_bob.reload.ptime_employee_id).to eq(23)
    expect(person_longmax.reload.ptime_employee_id).to eq(33)
    expect(person_charlie.reload.ptime_employee_id).to eq(45)
  end

  it 'should not map people that are not found' do
    parsed_company_employees_json = ptime_company_employees
    parsed_company_employees_json[:data].first[:attributes][:email] = "somemailthatdoesnotexist@example.com"

    stub_ptime_request(*ptime_company_request_data.values, parsed_company_employees_json.to_json)

    person_bob = people(:bob)
    person_longmax = people(:longmax)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run(should_map: true)

    expect(person_longmax.reload.ptime_employee_id).to be_nil
    expect(person_bob.reload.ptime_employee_id).to eq(23)
    expect(person_charlie.reload.ptime_employee_id).to eq(45)
  end

  it 'should not map people on dry run' do
    person_bob = people(:bob)
    person_longmax = people(:longmax)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run

    expect(person_bob.reload.ptime_employee_id).to be_nil
    expect(person_longmax.reload.ptime_employee_id).to be_nil
    expect(person_charlie.reload.ptime_employee_id).to be_nil
  end
end