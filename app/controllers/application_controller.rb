# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_person!

  def check_admin
    return false if helpers.admin?

    render 'unauthorized', status: :unauthorized
  end
end
