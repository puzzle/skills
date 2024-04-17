# frozen_string_literal: true

class PeopleSkills::FilterController < ApplicationController
  include ParamConverters

  helper_method :search_row,:search_skill, :search_level, :search_interest

  def search_row
    params[:rows].present? ? params[:rows].to_i : nil
  end
end