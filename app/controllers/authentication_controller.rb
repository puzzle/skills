require 'ldap_tools'

class AuthenticationController < ApplicationController
  skip_before_action :authorize

  def sign_in
    development_json = { ldap_uid: 'development_user', api_token: '1234' }
    return render json: development_json if Rails.env.development? && ENV['ENABLE_AUTH'].blank?

    username = params[:username]
    password = params[:password]

    return render_unauthorized('dis mami') unless username.present? && password.present?

    json = User.authenticate(username, password)

    if json[:error].nil?
      return render json: json
    end
    render_unauthorized(json)
  end
end
