# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_person!

  def admin?
    # return true if Rails.env.development? && ENV['ENABLE_AUTH'].blank?
    # return true if Rails.env.test? && ENV['FRONTEND_TESTS'].present?

    false
    # current_person.is_admin
  end
end
