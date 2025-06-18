# frozen_string_literal: true

class SkillSearch::FilterFormController < ApplicationController
  include ParamConverters

  helper_method :filter_params

  private

  def filter_params
    SkillSearch::FilterParams.new(params)
  end
end
