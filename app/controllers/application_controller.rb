# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_person!
  skip_before_action :verify_authenticity_token, only: :create


  def authenticate_person!
    super
  end
end
