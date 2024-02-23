# frozen_string_literal: true

# OpenID Connect Client
class OidcClient

  def external_login_url
    state = SecureRandom.hex(16)
    nonce = SecureRandom.hex(16)
    authorization_uri = client.authorization_uri(
      scope: config[:additional_scopes].presence,
      state: state,
      nonce: nonce
    )
    [authorization_uri, state]
  end

  def user_subject
    config[:user_subject]
  end

  def get_id_token(code:, state:)
    client.authorization_code = code
    access_token = client.access_token!(state: state)
    OpenIDConnect::ResponseObject::IdToken.decode(access_token.id_token, host_public_key)
  end

  private

  def client
    @client ||= init_client
  end

  def init_client
    OpenIDConnect::Client.new(
      identifier: config[:client_id],
      secret: config[:secret],
      host: config[:host],
      port: config[:host_port] || 443,
      scheme: config[:host_scheme] || 'https',
      authorization_endpoint: config[:authorization_endpoint],
      token_endpoint: config[:token_endpoint],
      redirect_uri: cryptopus_return_url
    )
  end

  def host_public_key
    json = JSON.parse(URI.parse(config[:certs_url]).open.read)
    JSON::JWK::Set.new json['keys']
  end

  def config
    AuthConfig.oidc_settings
  end

  def cryptopus_return_url
    protocol = Rails.application.config.force_ssl ? 'https://' : 'http://'
    "#{protocol}#{ENV['RAILS_HOST_NAME'] || 'localhost:3000'}/session/oidc"
  end

end
