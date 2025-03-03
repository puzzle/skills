require 'rails_helper'

describe Ptime::AssignEmployeeIds do

  it 'should map people with the correct puzzletime id' do
    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run(should_map: true)

    expect(person_longmax.reload.ptime_employee_id).to eq(33)
    expect(person_alice.reload.ptime_employee_id).to eq(21)
    expect(person_charlie.reload.ptime_employee_id).to eq(45)
  end

  it 'should not map people that are not found' do
    parsed_employees_json = ptime_employees
    parsed_employees_json[:data].first[:attributes][:email] = "somemailthatdoesnotexist@example.com"
    parsed_employees_json[:data].second[:attributes][:email] = "thismailalsodoesntexist@example.com"


    stub_ptime_request(parsed_employees_json.to_json)

    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run(should_map: true)

    expect(person_longmax.reload.ptime_employee_id).to be_nil
    expect(person_alice.reload.ptime_employee_id).to be_nil
    expect(person_charlie.reload.ptime_employee_id).to eq(45)
  end

  it 'should not map people on dry run' do
    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run

    expect(person_longmax.reload.ptime_employee_id).to be_nil
    expect(person_alice.reload.ptime_employee_id).to be_nil
    expect(person_charlie.reload.ptime_employee_id).to be_nil
  end
end
