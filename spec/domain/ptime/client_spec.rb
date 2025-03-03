require 'rails_helper'

describe Ptime::Client do
    it 'should be able to fetch employee data' do
        fetched_employees = Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
        expect(fetched_employees).to eq(ptime_employees_data)
    end

    it 'should not raise PTimeClientError if LAST_PTIME_ERROR is more than 5 minutes ago' do
        stub_env_var("LAST_PTIME_ERROR", 6.minutes.ago.to_s)
        fetched_employees = Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
        expect(fetched_employees).to eq(ptime_employees_data)
    end

    it 'should raise PTimeClientError page is unreachable' do
        stub_env_var("PTIME_BASE_URL", "irgend.oepp.is")
        stub_ptime_request(ptime_employees.to_json, "employees?per_page=1000", 404)
        expect {
            Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
        }.to raise_error(CustomExceptions::PTimeClientError)
    end

    it 'should raise PTimeClientError if LAST_PTIME_ERROR is less than 5 minutes ago' do
        stub_env_var("LAST_PTIME_ERROR", 4.minutes.ago.to_s)
        expect {
            Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
        }.to raise_error(CustomExceptions::PTimeTemporarilyUnavailableError)
    end
end
