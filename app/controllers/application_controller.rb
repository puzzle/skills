# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_auth_user!

  def render_unauthorized
    return false if helpers.admin?

    render 'unauthorized', status: :unauthorized
  end
end
