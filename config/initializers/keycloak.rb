Keycloak.configure do |config|
  config.server_url = "https://sso.puzzle.ch/auth"
  config.realm_id   = "pitc"
  config.logger     = Rails.logger
  if Rails.env.test? && ENV['FRONTEND_TESTS'] == '1'
    config.skip_paths = {
        get: [/^.+/],
        post: [/^.+/],
        delete: [/^.+/],
        patch: [/^.+/]
      }
  end
end
