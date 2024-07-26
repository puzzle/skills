# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_auth_user!
  around_action :switch_locale

  default_form_builder SkillsFormBuilder

  def switch_locale(&)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  def authenticate_auth_user!
    return super if helpers.devise?

    admin = AuthUser.find_by(email: 'conf_admin@skills.ch')
    raise 'User not found. This is highly likely due to a non-seeded database.' unless admin

    request.env['warden'].set_user(admin, :scope => :auth_user)
  end

  def render_unauthorized_not_admin
    render_unauthorized(helpers.admin?)
  end

  def render_unauthorized_not_conf_admin
    render_unauthorized(helpers.conf_admin?)
  end

  def render_unauthorized(unauthorized)
    return false if unauthorized

    redirect_to root_path if request.referer.nil?
    render_error('unauthorized', 'unauthorized', :unauthorized)
  end

  def render_error(title_key, body_key, status = :bad_request)
    render partial: 'error_modal',
           locals: { title: translate("devise.failure.titles.#{title_key}"),
                     body: translate("devise.failure.#{body_key}") },
           :status => status
  end

  def default_url_options
    active_locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
    { locale: active_locale }
  end
end
