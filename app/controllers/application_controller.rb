class ApplicationController < ActionController::API
  before_action :authorize

  def authorize
    return if Rails.env.development?

    if auth_params_present?
      return if authenticates?
    end

    render_unauthorized
  end

  protected

  def render_unauthorized(message = nil)
    render json: message, status: :unauthorized
  end

  private

  def auth_params_present?
    params[:ldap_uid].present? && params[:api_token].present?
  end

  def authenticates?
    ldap_uid = params[:ldap_uid]
    api_token = params[:api_token]

    user = User.find_by(ldap_uid: ldap_uid)
    user && user.api_token == api_token
  end

end
