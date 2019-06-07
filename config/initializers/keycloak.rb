Keycloak.configure do |config|
  config.server_url = ENV['SERVER_URL']
  config.realm_id   = ENV['REALM_ID']
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
