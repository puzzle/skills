# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_auth_user!

  helper_method :find_profile_by_keycloak_user

  def authenticate_auth_user!
    return super unless helpers.devise?

    admin = AuthUser.find_by(email: 'admin@skills.ch')
    raise 'User not found. This is highly likely due to a non-seeded database.' unless admin

    request.env['warden'].set_user(admin, :scope => :auth_user)
  end

  def render_unauthorized
    return false if helpers.admin?

    render_error('unauthorized', 'unauthorized', :unauthorized)
  end

  def render_error(title_key, body_key, status = :bad_request)
    render partial: 'error_modal',
           locals: { title: translate("devise.failure.titles.#{title_key}"),
                     body: translate("devise.failure.#{body_key}") },
           :status => status
  end
end
