require 'rails_helper'

describe Ptime::Client do
    before(:each) do
        ENV["PTIME_BASE_URL"] = "www.api.com"
        ENV["PTIME_API_USERNAME"] = ""
        ENV["PTIME_API_PASSWORD"] = ""
        stub_request(:get, "www.api.com").
            to_return(body: "abc".to_json, headers: { 'pagination-total-count': 200, 'pagination-per-page': 20, 'pagination-current-page': 5, 'pagination-total-pages': 10, 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
    end

    it 'should test' do
        Ptime::Client.new.get("");
    end
end
