# frozen_string_literal: true

class Api::EnvSettingsController < Api::ApplicationController

  def index
    render json: values
  end

  private

  def values
    {
      sentry: ENV.fetch('SENTRY_DSN_FRONTEND', nil),
      helplink: ENV.fetch('HELPLINK', nil)
    }
  end
end
