# frozen_string_literal: true

class CvSearchController < ApplicationController
  def index
    @cv_search_results = should_search? ? search_results : []
    @query_too_short = (params[:q].to_s.strip.length || 0) < 3

    found_in = search_results.flat_map { |entry| entry[:found_in] }
    @attributes = found_in.pluck(:attribute).compact.uniq
  end

  private

  def search_results
    PeopleSearch.new(Array(query).map(&:strip), search_skills: search_skills?).entries
  end

  def query
    params[:q]&.split(',')
  end

  def search_skills?
    params.key?(:search_skills)
  end

  def should_search?
    !(query.nil? || query.include?(nil) || @query_too_short)
  end
end
