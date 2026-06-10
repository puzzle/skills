# frozen_string_literal: true

class CvSearchController < ApplicationController
  def index
    @cv_search_results = should_search? ? search_results : []
    @query_too_short = (params[:q].to_s.strip.length || 0) < 3

    @associations = PeopleSearch.new(Array(query).map(&:strip), search_skills: search_skills?).associations
    @personal_details = PeopleSearch.new(Array(query).map(&:strip), search_skills: search_skills?).personal_details

    @attributes = {
      'Personal Data' => @personal_details,
      'Associations' => @associations
    }

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
