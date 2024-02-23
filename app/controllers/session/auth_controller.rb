# frozen_string_literal: true

class Session::OidcController < SessionController

  before_action :validate_state, only: :create

  def create
    if user_authenticator.authenticate!(code: params[:code], state: params[:state])
      create_session(user_passphrase)
      if current_user.oidc?
        redirect_after_sucessful_login
      else
        migrate_user_to_oidc
      end
    else
      raise 'openid connect authentication error'
    end
  end

  private

  def migrate_user_to_oidc
    session[:oidc_recrypt_user_id] = session.delete(:user_id)
    session[:oidc_recrypt_user_passphrase] = user_passphrase
    redirect_to recrypt_oidc_path
  end

  # use openid state for csrf protection
  def validate_state
    if state_invalid?
      raise 'openid connect csrf protection state invalid'
    end
  end

  def state_invalid?
    state = session.delete(:oidc_state)
    state != params[:state]
  end

  def authorize_action
    authorize :oidc, policy_class: SessionPolicy
  end

  def user_passphrase
    user_authenticator.user_passphrase
  end
end
