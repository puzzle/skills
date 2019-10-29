Keycloak.configure do |config|
  config.server_url = ENV['RAILS_KEYCLOAK_SERVER_URL']
  config.realm_id   = ENV['RAILS_KEYCLOAK_REALM_ID']
  config.logger     = Rails.logger
  config.skip_paths = {
    get: [/^\/assets\/.+/, /^\/styles\/.+/, /^\/healthz/, /^\/api\/env_settings/]
  }
  if (Rails.env.test? && ENV['FRONTEND_TESTS'].present?) || Rails.env.development?
    test_skips = {
        get: [/^.+/],
        post: [/^.+/],
        delete: [/^.+/],
        patch: [/^.+/]
      }
    config.skip_paths.merge!(test_skips)
  end
end
