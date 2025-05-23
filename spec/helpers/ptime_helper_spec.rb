require 'rails_helper'

describe 'PuzzleTime helpers', type: :helper do
  before(:each) do
    enable_ptime_sync
  end

  it 'should return correctly parsed ptime provider configs' do
    expect(helper.ptime_providers)
      .to match_array([
                        {BASE_URL: 'www.ptime.example.com', API_USERNAME: 'test username', API_PASSWORD: 'test password', COMPANY_IDENTIFIER: 'Firma'}.stringify_keys,
                        {BASE_URL: 'www.ptime-partner.example.com', API_USERNAME: 'test username 2', API_PASSWORD: 'test password 2', COMPANY_IDENTIFIER: 'Partner'}.stringify_keys
                      ])
  end

  it 'should detect invalid config' do
    stub_env_var('PTIME_PROVIDER_0_INVALID_CONFIG', nil)
    ENV.delete('PTIME_PROVIDER_0_')
    expect {helper.ptime_providers}.to raise_error(PtimeExceptions::InvalidProviderConfig, 'A config is missing or named wrongly. Make sure that
                                                                                             every config option is set for every provider.'.squish)
  end

  it 'should detect duplicate company identifiers' do
    stub_env_var('PTIME_PROVIDER_1_COMPANY_IDENTIFIER', 'Firma')
    expect {helper.ptime_providers}.to raise_error(PtimeExceptions::InvalidProviderConfig, 'Company identifiers have to be unique')
  end

  it 'should detect when company identifier does not exist' do
    stub_env_var('PTIME_PROVIDER_1_COMPANY_IDENTIFIER', 'Invalid Company')
    expect {helper.ptime_providers}.to raise_error(PtimeExceptions::InvalidProviderConfig, "The company with the identifier Invalid Company does not exist")
  end
end