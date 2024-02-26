Devise.setup do |config|
  config.omniauth :openid_connect, {
    name: :keycloak,
    scope: [:email],
    response_type: :code,
    uid_field: "preferred_username",
    client_options: {
      port: 443,
      scheme: "https",
      host: "sso-test.puzzle.ch",
      identifier: "pitc_skills_rails_backend",
      secret: "r609dv7dl50164n4rlga121ott",
      redirect_uri: "http://myapp.com/users/auth/openid_connect/callback",
    },
  }
end
