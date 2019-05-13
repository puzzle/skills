require 'ldap_tools'

class AuthenticationController < ApplicationController
  # skip_before_action :authorize

  def sign_in
    development_json = { ldap_uid: 'development_user', api_token: '1234' }
    return render json: development_json if auth_disabled?

    username = params[:username]
    password = params[:password]

    if invalid_params?(username, password)
      return render_unauthorized(error: 'Invalide Parameter')
    end

    json = User.authenticate(username, password)

    return render json: json if json[:error].nil?

    render_unauthorized(json)
  end

  def invalid_params?(username, password)
    username.blank? || password.blank? || (username =~ /^([a-zA-Z]|\d)+$/).nil?
  end

  private

  def auth_disabled?
    (Rails.env.development? && ENV['ENABLE_AUTH'].blank?) ||
      ENV['DISABLE_AUTH'].present?
  end

end
