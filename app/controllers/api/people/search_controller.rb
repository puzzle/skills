# frozen_string_literal: true

module Api::People
  class SearchController < Api::ApplicationController

    def index
      render json: search_results
    end

    private

    def search_results
      PeopleSearch.new(query).entries
    end

    def query
      params[:q]
    end
  end
end
