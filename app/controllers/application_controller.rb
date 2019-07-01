# frozen_string_literal: true

class ApplicationController < ActionController::API

  before_action :authorize

  def authorize
    return if Rails.env.development? && ENV['ENABLE_AUTH'].blank?
    return if ENV['DISABLE_AUTH'].present?

    if auth_params_present?
      return if authenticates?
    end

    render_unauthorized
  end

  protected

  def render_unauthorized(message = 'unauthorized')
    render json: message, status: :unauthorized
  end

  private

  def auth_params_present?
    request.headers['ldap-uid'].present? && request.headers['api-token'].present?
  end

  def authenticates?
    ldap_uid = request.headers['ldap-uid']
    api_token = request.headers['api-token']

    if Rails.env.test? && ldap_uid == 'development_user' && api_token == '1234'
      return true
    end

    user = User.find_by(ldap_uid: ldap_uid)
    user && user.api_token == api_token
  end

end
