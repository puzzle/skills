require 'rails_helper'

describe Ptime::Client do
    it 'should be able to fetch employee data' do
        fetched_employees = Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
        expect(fetched_employees).to eq(ptime_employees_data)
    end

    it 'should not raise PTimeClientError if LAST_PTIME_ERROR is less than 5 minutes ago' do
        ENV['LAST_PTIME_ERROR'] = 6.minutes.ago.to_s
        fetched_employees = Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
        expect(fetched_employees).to eq(ptime_employees_data)
    end

    it 'should raise PTimeClientError if LAST_PTIME_ERROR is less than 5 minutes ago' do
        ENV['LAST_PTIME_ERROR'] = 4.minutes.ago.to_s
        expect {
            Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
        }.to raise_error(CustomExceptions::PTimeClientError)
    end
end
