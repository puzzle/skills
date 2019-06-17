Keycloak.configure do |config|
  config.server_url = ENV['KEYCLOAK_SERVER_URL']
  config.realm_id   = ENV['KEYCLOAK_REALM_ID']
  config.logger     = Rails.logger
  if Rails.env.test? && ENV['FRONTEND_TESTS'].present?
    config.skip_paths = {
        get: [/^.+/],
        post: [/^.+/],
        delete: [/^.+/],
        patch: [/^.+/]
      }
  end
end
