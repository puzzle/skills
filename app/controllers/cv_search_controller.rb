# frozen_string_literal: true

class CvSearchController < ApplicationController
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

  def should_search
    query.nil? || query.length < 3
  end
end
