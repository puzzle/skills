# frozen_string_literal: true

class CvSearchController < ApplicationController
  include CvSearchConcerns
  def index
    @cv_search_results = should_search ? [] : search_results
  end

  private

  def search_results
    PeopleSearch.new(query).entries
  end

  def query
    params[:q]
  end
end
