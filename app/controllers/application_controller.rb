# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ParamConverters

  before_action :authenticate_auth_user!
  around_action :switch_locale

  default_form_builder SkillsFormBuilder

  def switch_locale(&)
    param_locale = params[:locale]
    unless param_locale || !auth_user_signed_in?
      return redirect_to(locale: cookies[:locale] || I18n.default_locale)
    end

    cookies.permanent[:locale] = param_locale unless params[:set_by_user].nil?
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

  def render_unauthorized(is_authorized)
    return false if is_authorized

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

  def current_ability
    @current_ability ||= Ability.new(current_auth_user)
  end
end
