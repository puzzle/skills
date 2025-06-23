require 'rails_helper'

describe Ptime::Client do
  it 'should be able to fetch employee data' do
    fetched_employees = Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
    expect(fetched_employees).to eq(ptime_employees_data)
  end

  it 'should raise PTimeClientError page is unreachable' do
    stub_env_var("PTIME_BASE_URL", "irgendoepis.example.com")
    stub_ptime_request(ptime_employees.to_json, "employees?per_page=1000", 404)
    expect {
      Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
    }.to raise_error(PtimeExceptions::PTimeClientError)
  end
end