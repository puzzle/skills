# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_auth_user!
  before_action :set_first_path!


  def authenticate_auth_user!
    return super if helpers.devise?

    admin = AuthUser.find_by(email: 'conf_admin@skills.ch')
    raise 'User not found. This is highly likely due to a non-seeded database.' unless admin

    request.env['warden'].set_user(admin, :scope => :auth_user)
  end

  def set_first_path!
    @first_path = Pathname(request.path).each_filename.to_a.map { |e| "/#{e}" }.first
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
end
