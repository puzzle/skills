# frozen_string_literal: true

module SkillSearch
  class SearchFilters
    attr_reader :filters, :results

    def initialize(params)
      @input   = FilterInput.new(params)
      @filters = []
      @results = []
    end

    def self.parse(...) = new(...).parse

    def parse
      @filters = @input.rows.map { SearchFilter.new(*it) }
      self
    end

    def apply
      return [] unless applicable_filters.any?

      people = yield(applicable_filters.map(&:skill_id))

      @results = people.select { |_person, skills| match_filters(skills) }
    end

    def no_matches?
      return false if results.any?
      return false if applicable_filters.none?

      true
    end

    def no_match_message
      NoMatchMessage.new(applicable_filters, @input.department)
    end

    def rows  = filters
    def count = filters.length

    def add_row = filters << SearchFilter.new
    def delete_row(index) = filters.delete_at(index)

    private

    def match_filters(skills)
      filter_groups.any? do |group|
        group = group.select(&:skill?)
        SearchFilter.group_match?(group, skills)
      end
    end

    def filter_groups = filters.slice_after(&:or?)
    def applicable_filters = filters.select(&:skill?)
  end
end
