# frozen_string_literal: true

class StatusController < ApplicationController
  skip_before_action :authenticate_auth_user!

  # Web Server Okay?
  def health
    render json: { status: :ok }
  end

  # Are we ready to serve requests?
  def readiness
    ready, status, message = assess_readiness
    http_code = ready ? :ok : :internal_server_error

    render json: { status: status, message: message }, status: http_code
  end

  def sentry_error
    1 / 0
  end

  private

  def assess_readiness
    return [true, :ok, 'OK'] if can_query_database?

    [false, :service_unavailable, 'ERROR: Can not connect to the database']
  end

  def can_query_database?
    ActiveRecord::Base.connection.execute('SELECT 1')
    true
  rescue ActiveRecord::StatementInvalid => e
    if e.message.match?(/^PG::ConnectionBad/)
      return false
    end

    raise.e
  end

end
