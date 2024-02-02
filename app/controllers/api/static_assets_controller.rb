# frozen_string_literal: true

class Api::StaticAssetsController < Api::ApplicationController
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception

  def index
    render file: Rails.root.join('public/index.html'), formats: [:html]
  end

end
