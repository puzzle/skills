require 'rails_helper'

describe EnvSettingsController do

  context 'GET index' do

    it 'returns env_settings with keycloak enabled' do

      keycloak_env_vars

      get :index

      settings = json

      expect(settings['sentry']).to eq('123456')
      expect(settings['helplink']).to eq('https://help.skills.test')

      settings_keycloak = settings['keycloak']
      expect(settings_keycloak['url']).to eq('keycloak.skills.test')
      expect(settings_keycloak['clientId']).to eq('test-client-id')
      expect(settings_keycloak['realm']).to eq('realm')
      expect(settings_keycloak['disabled']).to be_nil

    end

    it 'returns env_settings with keycloak disabled' do

      keycloak_disabled_env_vars

      get :index

      settings = json

      expect(settings['sentry']).to eq('123456')
      expect(settings['helplink']).to eq('https://help.skills.test')

      settings_keycloak = settings['keycloak']
      expect(settings_keycloak['url']).to be_nil
      expect(settings_keycloak['clientId']).to be_nil
      expect(settings_keycloak['realm']).to be_nil
      expect(settings_keycloak['disable']).to eq('true')

    end
  end
end

def keycloak_env_vars

  ENV['SENTRY_DSN_FRONTEND'] = '123456'
  ENV['HELPLINK'] = 'https://help.skills.test'

  ENV['EMBER_KEYCLOAK_SERVER_URL'] = 'keycloak.skills.test'
  ENV['EMBER_KEYCLOAK_CLIENT_ID'] = 'test-client-id'
  ENV['EMBER_KEYCLOAK_REALM_NAME'] = 'realm'

end

def keycloak_disabled_env_vars

  ENV['SENTRY_DSN_FRONTEND'] = '123456'
  ENV['HELPLINK'] = 'https://help.skills.test'

  ENV['EMBER_KEYCLOAK_SERVER_URL'] = nil
  ENV['EMBER_KEYCLOAK_CLIENT_ID'] = nil
  ENV['EMBER_KEYCLOAK_REALM_NAME'] = nil

  ENV['KEYCLOAK_DISABLED'] = '1'

end
