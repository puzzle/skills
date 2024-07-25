require 'rails_helper'

describe Ptime::Client do
    it 'should be able to fetch employee data' do
        fetched_employees = Ptime::Client.new.request(:get, "employees?per_page=1000")
        expect(fetched_employees).to eq(JSON.parse(return_ptime_employees_json))
    end
end
