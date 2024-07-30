require 'omniauth-keycloak'
require 'oauth2'


class SkillsKeycloakOmniauthStrategie < OmniAuth::Strategies::KeycloakOpenId


  def request_phase # rubocop:disable Metrics/AbcSize
    options.authorize_options.each { |key| options[key] = request.params[key.to_s] }
    url = client.auth_code.authorize_url({ :redirect_uri => callback_url }.merge(authorize_params))
    url = url.gsub(options.client_options[:site],
                   options.client_options[:keycloak_redirect_site])
    redirect url
  end
end
