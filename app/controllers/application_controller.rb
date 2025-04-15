# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_auth_user!
  around_action :switch_locale

  default_form_builder SkillsFormBuilder

  def switch_locale(&)
    param_locale = params[:locale]
    redirect_to(locale: cookies[:locale] || I18n.default_locale) unless param_locale
    cookies.permanent[:locale] = param_locale if true?(params[:set_by_user])
    I18n.with_locale(param_locale, &)
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
    { locale: I18n.locale }
  end
end
