class ApplicationController < ActionController::API
  before_action :authorize

  def authorize
    return if Rails.env.development? && ENV['ENABLE_AUTH'].blank?

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
    request.headers["ldap-uid"].present? && request.headers["api-token"].present?
  end

  def authenticates?
    ldap_uid = request.headers["ldap-uid"]
    api_token = request.headers["api-token"]

    user = User.find_by(ldap_uid: ldap_uid)
    user && user.api_token == api_token
  end

end
