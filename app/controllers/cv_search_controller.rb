# frozen_string_literal: true

class CvSearchController < ApplicationController
  def index
    @cv_search_results = should_search ? [] : search_results
  end

  private

  def search_results
    PeopleSearch.new(query, search_skills: search_skills?).entries
  end

  def query
    params[:q]
  end

  def search_skills?
    params.key?(:search_skills)
  end

  def should_search
    query.nil? || query.length < 3
  end
end
