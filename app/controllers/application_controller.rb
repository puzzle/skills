# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_person!

  def admin?
    current_person.is_admin
  end
end
