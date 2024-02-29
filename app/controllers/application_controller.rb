# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_person!

  def authenticate_person!
    # require 'pry'; binding.pry
    super
  end
end
