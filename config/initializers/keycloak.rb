Keycloak.configure do |config|
  config.server_url = "https://sso.puzzle.ch/auth"
  config.realm_id   = "pitc"
  config.logger     = Rails.logger
  config.skip_paths = {
    get: ["/^\/api\/people/.+"]
  }
end
