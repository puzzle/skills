class ApplicationController < ActionController::API
  before_action :authorize

  def authorize
    return if Rails.env.development?

    ldap_uid = params[:ldap_uid]
    api_token = params[:api_token]

    if auth_params_present?
      user = User.find_by(ldap_uid: ldap_uid)
      return if user && user.api_token == api_token
    end

    render_unauthorized
  end

  protected

  def render_unauthorized(message = nil)
    if message.nil?
      render status: :unauthorized
    else
      render json: message, status: :unauthorized
    end
  end

  private

  def auth_params_present?
    params[:ldap_uid].present? && params[:api_token].present?
  end

end
