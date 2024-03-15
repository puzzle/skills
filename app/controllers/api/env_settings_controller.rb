# frozen_string_literal: true

class Api::EnvSettingsController < Api::ApplicationController

  def index
    render json: values
  end

  private

  def values
    {
      sentry: ENV.fetch('SENTRY_DSN_FRONTEND', nil),
      helplink: ENV.fetch('HELPLINK', nil),
      keycloak: keycloak_info
    }
  end

  def keycloak_info
    {
      disable: Rails.application.keycloak_disabled? ? 'true' : nil,
      url: ENV.fetch('EMBER_KEYCLOAK_SERVER_URL', nil),
      realm: ENV.fetch('EMBER_KEYCLOAK_REALM_NAME', nil),
      clientId: ENV.fetch('EMBER_KEYCLOAK_CLIENT_ID', nil)
    }
  end

end
