# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_person!, :except => [:get, :create, :post]
  skip_before_action :verify_authenticity_token, only: :create


  def authenticate_person!
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    super
  end

  def new_session_path(_scope)
    new_person_session_path
  end
end
