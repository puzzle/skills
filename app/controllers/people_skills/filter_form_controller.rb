# frozen_string_literal: true

class PeopleSkills::FilterFormController < ApplicationController
  include ParamConverters
  include PeopleSkills

  helper_method :search_row, :search_skill, :search_level, :search_interest, :query_params

  def index
    @converted_params = Params.new(params)
  end


end
