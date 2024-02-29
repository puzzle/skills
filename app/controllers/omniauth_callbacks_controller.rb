class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def openid_connect
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    omniauth_auth = request.env['omniauth.auth']
    @user = Person.from_omniauth(omniauth_auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Keycloak') if is_navigational_format?
    else
      failure
    end
  end

  def keycloak_openid
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    # openid_connect
  end

  def failure
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    redirect_to root_path
  end
end
