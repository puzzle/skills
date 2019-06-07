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

  it 'fails to access skills without the admin role' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer #{jwt}"
     }
    get '/api/skills', :params => '', :headers => headers
    expect(response.status).to eq(401)
  end

  it 'succeeds to access skills with the admin role' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer #{jwt_with_admin}"
     }
    get '/api/skills', :params => '', :headers => headers
    expect(response.status).to eq(200)
  end
end
