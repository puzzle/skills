# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :keycloak_openid

  def keycloak_openid
    omniauth_auth = request.env['omniauth.auth']
    @user = AuthUser.from_omniauth(omniauth_auth)
    @relevant_role = AuthConfig.relevant_keycloak_role

    return failure if omniauth_auth.extra.blank?

    if @user.persisted? && keycloak_roles(omniauth_auth).include?(@relevant_role)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Keycloak') if is_navigational_format?
    else
      failure
    end
  end

  def failure
    redirect_to '/auth_error'
  end

  private

  def keycloak_roles(omniauth_auth)
    omniauth_auth[:extra][:raw_info][:pitc][:roles]
  end
end
