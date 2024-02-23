Rails.application.config.middleware.use OmniAuth::Builder do
  provider :keycloak_openid, 'pitc_skills_rails_backend', 'r609dv7dl50164n4rlga121ott',
    client_options: {site: 'https://sso-test.puzzle.ch', realm: 'pitc'},
    name: 'pitc_skills_rails_backend'
end
