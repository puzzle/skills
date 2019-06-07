RSpec.shared_context "Keycloak" do
  let(:jwt) do
    claims = {
      iat: Time.zone.now.to_i,
      exp: (Time.zone.now + 1.day).to_i,
    }
    token = JSON::JWT.new(claims)
    token.kid = "default"
    token.sign($private_key, :RS256).to_s
  end

  let(:jwt_with_admin) do
    claims = {
      iat: Time.zone.now.to_i,
      exp: (Time.zone.now + 1.day).to_i,
      resource_access: {
        'pitc-skills-frontend': {
          roles: "ADMIN"
        }
      }
    }
    token = JSON::JWT.new(claims)
    token.kid = "default"
    token.sign($private_key, :RS256).to_s
  end

  before(:each) do
    public_key_resolver = Keycloak.public_key_resolver
    allow(public_key_resolver).to receive(:find_public_keys) { JSON::JWK::Set.new(JSON::JWK.new($private_key, kid: "default")) }
  end
end
