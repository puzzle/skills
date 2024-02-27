# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_person!


  def new_session_path(_scope)
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    new_person_session_path
  end

  def session_path(_scope)
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    person_session
  end
end
