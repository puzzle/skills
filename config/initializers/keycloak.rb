KEYCLOAK_ENV_VARS = %w[RAILS_KEYCLOAK_SERVER_URL RAILS_KEYCLOAK_REALM_ID EMBER_KEYCLOAK_SERVER_URL EMBER_KEYCLOAK_REALM_NAME EMBER_KEYCLOAK_CLIENT_ID EMBER_KEYCLOAK_SECRET]

def keycloak_disabled?
  KEYCLOAK_ENV_VARS.none? {|e| ENV[e].present?} && ENV['RAILS_KEYCLAOK_DISABLED'].present?
end

Keycloak.configure do |config|
  config.server_url = ENV['RAILS_KEYCLOAK_SERVER_URL']
  config.realm_id   = ENV['RAILS_KEYCLOAK_REALM_ID']
  config.logger     = Rails.logger
  config.skip_paths = {
    get: [/^\/assets\/.+/, /^\/styles\/.+/, /^\/healthz/, /^\/api\/env_settings/]
  }
  if (Rails.env.test? && ENV['FRONTEND_TESTS'].present?) || Rails.env.development? || keycloak_disabled?
    test_skips = {
        get: [/^.+/],
        post: [/^.+/],
        delete: [/^.+/],
        patch: [/^.+/]
      }
    config.skip_paths.merge!(test_skips)
  end
end
