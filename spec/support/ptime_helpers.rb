module PtimeHelpers
    def set_env_variables_and_stub_request
        ptime_base_test_url = "www.ptime.example.com"
        ptime_api_test_username = "test username"
        ptime_api_test_password = "test password"
        ENV["PTIME_BASE_URL"] = ptime_base_test_url
        ENV["PTIME_API_USERNAME"] = ptime_api_test_username
        ENV["PTIME_API_PASSWORD"] = ptime_api_test_password

        stub_request(:get, "http://#{ptime_base_test_url}/api/v1/employees?per_page=1000").
        to_return(body: return_ptime_employees_json, headers: { 'content-type': "application/vnd.api+json; charset=utf-8" }, status: 200)
                                                    .with(basic_auth: [ptime_api_test_username, ptime_api_test_password])
    end

    def return_ptime_employees_json
        json_data filename: "all_ptime_employees"
    end
end
