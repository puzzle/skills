class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def openid_connect
    @user = Person.from_omniauth(request.env['omniauth.auth']).save
    sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
    set_flash_message(:notice, :success, kind: 'Keycloak') if is_navigational_format?
  end

  def failure
    redirect_to root_path
  end
end
