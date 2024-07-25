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
    parsed_employees_json = JSON.parse(return_ptime_employees_json)
    parsed_employees_json['data'].first["attributes"]["firstname"] = "Rochus"
    parsed_employees_json['data'].second["attributes"]["firstname"] = "Melchior"
    stub_request(:get, "#{ENV["PTIME_BASE_URL"]}/api/v1/employees?per_page=1000").
      to_return(body: parsed_employees_json.to_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                               .with(basic_auth: [ENV["PTIME_API_USERNAME"], ENV["PTIME_API_PASSWORD"]])

    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    Ptime::AssignEmployeeIds.new.run(should_map: true)

    expect(person_longmax.reload.ptime_employee_id).to be_nil
    expect(person_alice.reload.ptime_employee_id).to be_nil
    expect(person_charlie.reload.ptime_employee_id).to eq(45)
  end

  it 'should not map people that are ambiguous' do
    person_longmax = people(:longmax)
    person_alice = people(:alice)
    person_charlie = people(:charlie)

    person_charlie.name = "Alice Mante"
    person_charlie.email = "alice@example.com"
    person_charlie.save!

    Ptime::AssignEmployeeIds.new.run(should_map: true)

    expect(person_longmax.reload.ptime_employee_id).to eq(33)
    expect(person_alice.reload.ptime_employee_id).to be_nil
    expect(person_charlie.reload.ptime_employee_id).to be_nil
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
