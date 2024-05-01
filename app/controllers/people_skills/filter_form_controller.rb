# frozen_string_literal: true

class PeopleSkills::FilterFormController < ApplicationController
  include ParamConverters

  helper_method :filter_params

  private

  def filter_params
    PeopleSkills::FilterParams.new(params)
  end
end
