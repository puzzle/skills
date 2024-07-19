require 'rails_helper'

ptime_base_test_url = "www.ptime.example.com"
ptime_api_test_username = "test username"
ptime_api_test_password = "test password"
ENV["PTIME_BASE_URL"] = ptime_base_test_url
ENV["PTIME_API_USERNAME"] = ptime_api_test_username
ENV["PTIME_API_PASSWORD"] = ptime_api_test_password

describe Ptime::Client do
    it 'should be able to fetch employee data' do
        stub_request(:get, "#{ptime_base_test_url}/api/v1/employees").
          to_return(body: return_ptime_employees_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                                       .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])

        fetched_employees = Ptime::Client.new.request(:get, "employees")
        expect(fetched_employees).to eq(JSON.parse(return_ptime_employees_json))
    end

    it 'should fallback to skills if last request was right now' do
        ENV['LAST_PTIME_API_REQUEST'] = DateTime.current.to_s

        skills_people = Ptime::Client.new.request(:get, "employees")

        expect(ENV['PTIME_API_ACCESSIBLE']).to eq('false')
    end
end
