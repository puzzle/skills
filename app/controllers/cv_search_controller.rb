# frozen_string_literal: true

class CvSearchController < ApplicationController
  def index
    @cv_search_results = should_search ? [] : filter_results
  end

  private

  def search_results
    PeopleSearch.new(query.map(&:strip), search_skills: search_skills?).entries
  end

  def filter_results
    category = params[:category].presence
    results = search_results

    return results unless category

    results.select { |person| match_category?(person, category) }
  end

  def match_category?(person, category)
    person[:found_in] = person[:found_in].select do |match|
      match[:attribute].to_s.downcase.include?(category.downcase)
    end
    person[:found_in].any?
  end

  def query
    params[:q]&.split(',')
  end

  def search_skills?
    params.key?(:search_skills)
  end

  def should_search
    query.nil? || query.include?(nil) || query.any? { |keyword| keyword.length < 3 }
  end
end
