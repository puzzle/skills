class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def openid_connect
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = Person.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
