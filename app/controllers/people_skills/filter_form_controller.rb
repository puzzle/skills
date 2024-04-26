# frozen_string_literal: true

class PeopleSkills::FilterFormController < ApplicationController
  include ParamConverters
  include PeopleSkills

  def index
    @converted_params = Params.new(params)
  end
end
