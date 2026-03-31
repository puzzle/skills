# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ParamConverters

  before_action :authenticate_auth_user!
  around_action :switch_locale

  helper_method :auth_users_for_select


  default_form_builder SkillsFormBuilder

  def switch_locale(&)
    param_locale = params[:locale]
    unless param_locale || !auth_user_signed_in?
      return redirect_to(locale: cookies[:locale] || I18n.default_locale)
    end

    cookies.permanent[:locale] = param_locale unless params[:set_by_user].nil?
    I18n.with_locale(param_locale, &)
  end

  def auth_users_for_select
    AuthUser.all.map do |a|
      path = url_for(auth_user_id: a.id, only_path: true)
      [
        a.name, path,
        {
          'data-html': "<a href='#{path}' class='dropdown-option-link'>#{a.name}</a>",
          class: 'p-0'
        }
      ]
    end
  end

  # The parameter opts = {} accepts the Warden options,
  # which Devise expects as a hash during authentication and passes on.
  # This allows you to control the login behaviour for each request.
  # We don't need the options at all, but since Devise v5.0.2 we have to define them.
  # e.g. to suppress cookies for APIs (store: false) or to force a re-login (force: true).
  def authenticate_auth_user!(opts = {})
    return super if helpers.devise?

    auth_user = AuthUser.find_by(id: params[:auth_user_id] || current_auth_user&.id || 1)
    raise 'User not found. This is highly likely due to a non-seeded database.' unless auth_user

    request.env['warden'].set_user(auth_user, :scope => :auth_user)
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
