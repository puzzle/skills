# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_auth_user!

  helper_method :find_profile_by_keycloak_user

  # def authenticate_auth_user!
  #   require 'pry'; binding.pry
  #   return super unless helpers.development?

  #   admin = AuthUser.find_by(email: 'admin@skills.ch')
  #   request.env['warden'].set_user(admin, :scope => :auth_user)
  # end

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

  protected

  def find_profile_by_keycloak_user
    Person.find_by(name: current_auth_user&.name)
  end
end
