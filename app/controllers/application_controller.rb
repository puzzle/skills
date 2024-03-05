# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_auth_user!

  def render_unauthorized
    return false if helpers.admin?

    render 'unauthorized', status: :unauthorized
  end

  def authenticate_auth_user!
    super unless ENV['DEVELOPMENT'] == 'true'

    admin = AuthUser.find_by(email: 'admin@skills.ch')
    request.env['warden'].set_user(admin, :scope => :auth_user)
  end
end
