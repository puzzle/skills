require 'rails_helper'
require 'support/keycloak_helpers.rb'

describe 'Keycloak' do
  include_context 'Keycloak'

  it 'fails without header' do
    get '/api/companies'
    expect(response.status).to eq(401)
  end

  it 'fails with wrong token' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer 1234"
     }
    get '/api/companies', :params => '', :headers => headers
    expect(response.status).to eq(401)
  end

  it 'succeeds with a good token' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer #{jwt}"
     }
    get '/api/companies', :params => '', :headers => headers
    expect(response.status).to eq(200)
  end
end
