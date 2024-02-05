# frozen_string_literal: true

Keycloak.configure do |config|

  config.server_url = ENV['RAILS_KEYCLOAK_SERVER_URL']
  config.realm_id   = ENV['RAILS_KEYCLOAK_REALM_ID']
  config.logger     = Rails.logger
  config.ca_certificate_file = "/etc/ssl/certs/ca-certificates.crt"
  config.skip_paths = {
    get: [/^\/assets\/.+/, /^\/styles\/.+/, /^\/healthz/, /^\/api\/env_settings/, /^\/status\/(.*)/, /^\/img\/.+/]
  }
  if  Rails.env.test? || Rails.env.development? || Rails.application.keycloak_disabled?
    test_skips = {
      get: [/^.+/],
      post: [/^.+/],
      delete: [/^.+/],
      patch: [/^.+/],
      put: [/^.+/]
    }
    config.skip_paths.merge!(test_skips)
  end
end
