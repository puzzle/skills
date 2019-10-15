class EnvSettingsController < ApplicationController
  def index
    render json: values
  end

  private

  def values
    {
        sentry: ENV['SENTRY_DSN_FRONTEND'].to_s,
        rails_port: ENV['RAILS_PORT'].to_s,
        helplink: ENV['HELPLINK'].to_s,
        keycloak: keycloak_info
    }
  end

  def keycloak_info
    {
        url: ENV['EMBER_KEYCLOAK_SERVER_URL'].to_s,
        realm: ENV['EMBER_KEYCLOAK_REALM_NAME'].to_s,
        clientId: ENV['EMBER_KEYCLOAK_CLIENT_ID'].to_s,
        secret: ENV['EMBER_KEYCLOAK_SECRET'].to_s
    }
  end
end
