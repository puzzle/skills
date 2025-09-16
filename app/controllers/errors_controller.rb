# frozen_string_literal: true

class ErrorsController < ApplicationController
  layout false

  skip_before_action :authenticate_auth_user!

  def auth_error
    # Renders app/views/errors/auth_error.html.erb
  end
end
