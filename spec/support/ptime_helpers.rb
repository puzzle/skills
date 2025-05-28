module PtimeHelpers
  def enable_ptime_sync
    PeopleController.permitted_attrs = PeopleController.instance_variable_get("@ptime_permitted_attrs")
    stub_env_var("PTIME_PROVIDER_0_BASE_URL", "www.ptime.example.com")
    stub_env_var("PTIME_PROVIDER_0_API_USERNAME", "test username")
    stub_env_var("PTIME_PROVIDER_0_API_PASSWORD", "test password")
    stub_env_var("PTIME_PROVIDER_0_COMPANY_IDENTIFIER", "Firma")

    stub_env_var("PTIME_PROVIDER_1_BASE_URL", "www.ptime-partner.example.com")
    stub_env_var("PTIME_PROVIDER_1_API_USERNAME", "test username 2")
    stub_env_var("PTIME_PROVIDER_1_API_PASSWORD", "test password 2")
    stub_env_var("PTIME_PROVIDER_1_COMPANY_IDENTIFIER", "Partner")

    stub_env_var("USE_PTIME_SYNC", true)
    stub_ptime_request(*ptime_company_request_data.values, ptime_company_employees.to_json)
    stub_ptime_request(*ptime_partner_request_data.values, ptime_partner_employees.to_json)
  end

  def ptime_company_employees
    fixture_data("all_ptime_employees_company")
  end

  def ptime_company_employee_data
    fixture_data("all_ptime_employees_company")[:data]
  end

  def ptime_partner_employees
    fixture_data("all_ptime_employees_partner")
  end

  def ptime_partner_employee_data
    fixture_data("all_ptime_employees_partner")[:data]
  end

  def ptime_company_request_data
    { BASE_URL: 'www.ptime.example.com', API_USERNAME: 'test username', API_PASSWORD: 'test password' }.with_indifferent_access
  end

  def ptime_partner_request_data
    { BASE_URL: 'www.ptime-partner.example.com', API_USERNAME: 'test username 2', API_PASSWORD: 'test password 2' }.with_indifferent_access
  end

  def stub_ptime_request(base_url, username, password, return_body, path=nil, status=200)
    path ||= "employees?per_page=1000"
    url = "http://#{base_url}/api/v1/#{path}"
    content_type = "application/vnd.api+json; charset=utf-8"

    stub_request(:get, url)
      .to_return(body: return_body, headers: { 'content-type': content_type }, status: status)
      .with(basic_auth: [username, password])
  end

  def stub_env_var(name, value)
    allow(ENV).to receive(:fetch).with(name).and_return(value)
    stub_const('ENV', ENV.to_hash.merge(name => value))
  end

  def employee_full_name(ptime_employee)
    "#{ptime_employee[:firstname]} #{ptime_employee[:lastname]}"
  end

  def stub_invalid_ptime_response
    company_employees = ptime_company_employees
    longmax_attributes = company_employees[:data].first[:attributes]
    longmax_attributes[:email] = ''
    stub_ptime_request(*ptime_company_request_data.values, company_employees.to_json)

    partner_employees = ptime_partner_employees
    bob_attributes = partner_employees[:data].first[:attributes]
    bob_attributes[:email] = ''
    stub_ptime_request(*ptime_partner_request_data.values, partner_employees.to_json)

    [longmax_attributes, bob_attributes]
  end
end