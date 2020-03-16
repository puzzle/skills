require 'rails_helper'
require 'support/keycloak_helpers.rb'

describe 'Keycloak' do
  include_context 'Keycloak'

  it 'fails without header' do
    get '/api/skills'
    expect(response.status).to eq(401)
  end

  it 'fails with wrong token' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer 1234"
     }
    get '/api/skills', :params => '', :headers => headers
    expect(response.status).to eq(401)
  end

  it 'succeeds with a good token' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer #{jwt}"
     }
    get '/api/skills', :params => '', :headers => headers
    expect(response.status).to eq(200)
  end

  it 'succeeds to read skills without the admin role' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer #{jwt}"
     }
    get '/api/skills', :params => '', :headers => headers
    expect(response.status).to eq(200)
  end
  
  it 'fails to create skills without the admin role' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer #{jwt}"
     }
    post '/api/skills', :params => '', :headers => headers
    expect(response.status).to eq(401)
  end

  it 'succeeds to read skills with the admin role' do
    headers = {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer #{jwt_with_admin}"
     }
    get '/api/skills', :params => '', :headers => headers
    expect(response.status).to eq(200)
  end
end
