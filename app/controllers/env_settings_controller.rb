# frozen_string_literal: true

class EnvSettingsController < ApplicationController

  def index
    render json: values
  end

  private

  def values
    {
      sentry: ENV['SENTRY_DSN_FRONTEND'],
      rails_port: ENV['RAILS_PORT'],
      helplink: ENV['HELPLINK'],
      keycloak: keycloak_info
    }
  end

  def keycloak_info
    {
      url: ENV['EMBER_KEYCLOAK_SERVER_URL'],
      realm: ENV['EMBER_KEYCLOAK_REALM_NAME'],
      clientId: ENV['EMBER_KEYCLOAK_CLIENT_ID'],
      secret: ENV['EMBER_KEYCLOAK_SECRET']
    }
  end
end
