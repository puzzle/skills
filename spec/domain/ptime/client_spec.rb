require 'rails_helper'

describe Ptime::Client do

  before(:each) do
    enable_ptime_sync
  end

  it 'should be able to fetch employee data' do
    fetched_employees = Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
    expect(fetched_employees).to eq(ptime_employees_data)
  end

  it 'should raise PtimeClientError when page is unreachable' do
    stub_env_var("PTIME_BASE_URL", "irgendoepis.example.com")
    stub_ptime_request(ptime_employees.to_json, "employees?per_page=1000", 404)
    expect {
      Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
    }.to raise_error(PtimeExceptions::PtimeClientError)
  end

  it 'should raise PtimeBaseUrlNotSet when ptime sync is active but base url is not set' do
    stub_env_var('PTIME_BASE_URL', nil)
    expect {
      Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
    }.to raise_error(PtimeExceptions::PtimeBaseUrlNotSet)
  end
end