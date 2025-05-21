require 'rails_helper'

describe 'PuzzleTime helpers', type: :helper do
  it 'should return correctly parsed ptime provider config' do
    enable_ptime_sync
    expect(helper.ptime_providers)
      .to match_array([
                        {BASE_URL: 'www.ptime.example.com', API_USERNAME: 'test username', API_PASSWORD: 'test password', COMPANY_IDENTIFIER: 'Firma'}.stringify_keys,
                        {BASE_URL: 'www.ptime-partner.example.com', API_USERNAME: 'test username 2', API_PASSWORD: 'test password 2', COMPANY_IDENTIFIER: 'Partner'}.stringify_keys
                      ])
  end
end