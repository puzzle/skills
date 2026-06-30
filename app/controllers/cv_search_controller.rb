# frozen_string_literal: true

class CvSearchController < ApplicationController
  def index
    @cv_search_results = should_search? ? search_results : []
    @query_too_short = query.blank? || query.any? { |q| q.strip.length < 3 }
  end

  private

  def search_results
    PeopleSearch.new(query.map(&:strip), search_skills: search_skills?,
                                         handle_whitespaces: handle_whitespaces?).entries
  end

  def query
    params[:q]&.split(',')
  end

  def search_skills?
    params.key?(:search_skills)
  end

  def handle_whitespaces?
    params.key?(:handle_whitespaces)
  end

  def should_search?
    !(query.nil? || query.include?(nil) || @query_too_short)
  end
end
