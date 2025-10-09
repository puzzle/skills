module OmniauthMacros
  def mock_omniauth_user(roles = [])
    OmniAuth::AuthHash.new(
      provider: 'keycloak_openid',
      uid: '123545',
      info: {
        name: 'Test User',
        email: 'test@example.com'
      },
      extra: {
        raw_info: {
          pitc: {
            roles: roles
          }
        }
      }
    )
  end
end

RSpec.configure do |config|
  config.include OmniauthMacros
  OmniAuth.config.test_mode = true
end
