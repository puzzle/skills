require 'rails_helper'

describe EnvSettingsController, type: :controller do
  describe 'GET index' do
    before do
      ENV['SENTRY_DSN_FRONTEND'] = 'fake-dsn'
      ENV['EMBER_KEYCLOAK_SECRET'] = 'fake-secret'
      ENV['EMBER_KEYCLOAK_CLIENT_ID'] = 'fake-id'
      ENV['EMBER_KEYCLOAK_REALM_NAME'] = 'fake-realm'
      ENV['RAILS_PORT'] = 'fake-port'
      ENV['HELPLINK'] = 'fake-link'

    end
    it 'returns env_settigns' do
      get :index
      settings = json
      settings_keycloak = settings['keycloak']
      expect(settings['sentry']).to eq('fake-dsn')
      expect(settings['helplink']).to eq('fake-link')
      expect(settings['rails_port']).to eq('fake-port')
      expect(settings_keycloak['secret']).to eq('fake-secret')
      expect(settings_keycloak['clientId']).to eq('fake-id')
      expect(settings_keycloak['realm']).to eq('fake-realm')
    end
  end
end
