require 'rails_helper'

describe Ptime::Client do
    it 'should be able to fetch employee data' do
        fetched_employees = Ptime::Client.new.request(:get, "employees", { per_page: 1000 })
        ptime_employee_json = fixture_data("all_ptime_employees")
        expect(fetched_employees).to eq(ptime_employee_json)
    end
end
