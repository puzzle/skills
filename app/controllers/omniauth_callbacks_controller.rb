class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :openid_connect

  def openid_connect
    omniauth_auth = request.env['omniauth.auth']
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    @user = Person.from_omniauth(omniauth_auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Keycloak') if is_navigational_format?
    else
      failure
    end
  end

  def failure
    redirect_to root_path
  end
end
