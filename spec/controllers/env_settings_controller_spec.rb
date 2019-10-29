require 'rails_helper'

describe EnvSettingsController do
  context 'GET index' do
    before do

      ENV['SENTRY_DSN_FRONTEND'] = '123456'
      ENV['HELPLINK'] = 'https://help.skills.test'
      ENV['EMBER_KEYCLOAK_SERVER_URL'] = 'keycloak.skills.test'
      ENV['EMBER_KEYCLOAK_SECRET'] = '1234'
      ENV['EMBER_KEYCLOAK_CLIENT_ID'] = 'test-client-id'
      ENV['EMBER_KEYCLOAK_REALM_NAME'] = 'realm'

    end

    it 'returns env_settings' do

      get :index

      settings = json
      settings_keycloak = settings['keycloak']

      expect(settings['sentry']).to eq('123456')
      expect(settings['helplink']).to eq('https://help.skills.test')
      expect(settings_keycloak['url']).to eq('keycloak.skills.test')
      expect(settings_keycloak['secret']).to eq('1234')
      expect(settings_keycloak['clientId']).to eq('test-client-id')
      expect(settings_keycloak['realm']).to eq('realm')

    end
  end
end
