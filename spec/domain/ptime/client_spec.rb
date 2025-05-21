require 'rails_helper'

describe Ptime::Client do

  before(:each) do
    enable_ptime_sync
  end

  it 'should be able to fetch employee data' do
    fetched_employees = Ptime::Client.new(ptime_company_request_data)
                                     .request(:get, "employees", { per_page: 1000 })
    expect(fetched_employees).to eq(ptime_company_employee_data)

    fetched_employees = Ptime::Client.new(ptime_partner_request_data)
                                     .request(:get, "employees", { per_page: 1000 })
    expect(fetched_employees).to eq(ptime_partner_employee_data)
  end

  it 'should raise PtimeClientError when page is unreachable' do
    invalid_ptime_company_request_data = ptime_company_request_data
    invalid_ptime_company_request_data[:base_url] = 'irgendoepis.example.com'
    stub_ptime_request(*invalid_ptime_company_request_data.values, "employees?per_page=1000", 404)
    expect {
      Ptime::Client.new(invalid_ptime_company_request_data).request(:get, "employees", { per_page: 1000 })
    }.to raise_error(PtimeExceptions::PtimeClientError)
  end
end