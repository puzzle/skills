module PtimeHelpers
    def stub_env_variables_and_request
        stub_env_var("PTIME_BASE_URL", "www.ptime.example.com")
        stub_env_var("PTIME_API_USERNAME", "test username")
        stub_env_var("PTIME_API_PASSWORD", "test password")
        stub_ptime_request(ptime_employees.to_json)
    end

    def ptime_employees
        fixture_data("all_ptime_employees")
    end

    def ptime_employees_data
        fixture_data("all_ptime_employees")[:data]
    end

    def stub_ptime_request(return_body, path =nil)
        path ||= "employees?per_page=1000"
        url = "http://#{ENV["PTIME_BASE_URL"]}/api/v1/#{path}"
        content_type = "application/vnd.api+json; charset=utf-8"

        stub_request(:get, url)
            .to_return(body: return_body, headers: { 'content-type': content_type }, status: 200)
            .with(basic_auth: [ENV["PTIME_API_USERNAME"], ENV["PTIME_API_PASSWORD"]])
    end

    def use_skills_db
        allow_any_instance_of(RestClient::Request)
       .to receive(:execute)
       .and_raise(RestClient::ExceptionWithResponse)
    end

    def stub_env_var(name, value)
        allow(ENV).to receive(:fetch).with(name).and_return(value)
        stub_const('ENV', ENV.to_hash.merge(name => value))
    end
end
