require 'rails_helper'

ENV["PTIME_BASE_URL"] = "www.api.com"
ENV["PTIME_API_USERNAME"] = "test username"
ENV["PTIME_API_PASSWORD"] = "test password"

describe Ptime::Client do
    before(:each) do
        stub_request(:get, "#{ENV["PTIME_BASE_URL"]}/api/v1/employees").
            to_return(body: "abc".to_json, headers: { 'pagination-total-count': 200, 'pagination-per-page': 20, 'pagination-current-page': 5, 'pagination-total-pages': 10, 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
    end

    it 'should be able to fetch employee data' do
        fetched_employees = Ptime::Client.new.get("employees");
    end
end
