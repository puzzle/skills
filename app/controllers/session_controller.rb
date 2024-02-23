# frozen_string_literal: true

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

class SessionController < ApplicationController
  # it's save to disable this for authenticate since there is no logged in session active
  # in this case.
  # caused problem with login form since the server side session is getting invalid after
  # configured timeout.
  skip_before_action :verify_authenticity_token, only: :create
  # skip_before_action :validate_user, only: [:new, :create, :destroy]
  # skip_before_action :redirect_if_no_private_key, only: [:destroy, :new]

  before_action :authorize_action
  before_action :skip_authorization, only: [:create, :new, :destroy]
  before_action :assert_logged_in, only: :destroy

  layout 'session', only: :new

  def create
    unless user_authenticator.authenticate!
      flash[:error] = t('flashes.session.auth_failed')
      return redirect_to user_authenticator.login_path
    end

    unless create_session(params[:password])
      return redirect_to user_authenticator.recrypt_path
    end

    check_password_strength
    redirect_after_sucessful_login
  end

  def destroy
    flash_notice = params[:autologout] ? t('session.destroy.expired') : flash[:notice]
    jumpto = params[:jumpto]
    redirect_path = destroy_redirect_path
    reset_session
    session[:jumpto] = jumpto
    flash[:notice] = flash_notice
    redirect_to redirect_path
  end

  def destroy_redirect_path
    if current_user.root?
      session_local_path
    else
      session_new_path
    end
  end

  private

  def assert_logged_in
    return if user_logged_in?

    redirect_to user_authenticator.login_path
  end

  def last_login_message
    flash_message = Flash::LastLoginMessage.new(session)
    flash[:notice] = flash_message.message if flash_message
  end

  def check_password_strength
    strength = PasswordStrength.test(params[:username], params[:password])

    if strength.weak? || !strength.valid?
      flash[:alert] = t('flashes.session.weak_password')
    end
  end

  def create_session(password)
    begin
      user = user_authenticator.user
      set_session_attributes(user, password)
      user_authenticator.update_user_info(request.remote_ip)
      Crypto::Rsa.validate_keypair(session[:private_key], user.public_key)
    rescue Exceptions::DecryptFailed
      return false
    end
    true
  end

  def redirect_after_sucessful_login
    jump_to = session.delete(:jumpto) || '/dashboard'
    redirect_to jump_to
  end

  def set_session_attributes(user, pk_secret)
    jumpto = session[:jumpto]
    reset_session
    session[:jumpto] = jumpto
    session[:username] = user.username
    session[:user_id] = user.id.to_s
    session[:private_key] = user.decrypt_private_key(pk_secret)
    session[:last_login_at] = user.last_login_at
    session[:last_login_from] = user.last_login_from
  end

  def authorize_action
    authorize :session
  end

  def oidc_client
    @oidc_client ||= OidcClient.new
  end
end
