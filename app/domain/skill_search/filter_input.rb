# frozen_string_literal: true

module SkillSearch
  class FilterInput
    attr_reader :department

    def initialize(params)
      @skill_ids  = params[:skill_id]
      @levels     = params[:level]
      @interests  = params[:interest]&.values
      @operators  = params[:operator]&.values || []
      @department = params[:department].presence&.to_i
    end

    def rows
      return [] unless valid?

      @skill_ids.zip(@levels, @interests, @operators)
    end

    private

    def valid?
      @skill_ids.present? && equal_length_parameters?
    end

    def equal_length_parameters?
      [@skill_ids, @levels, @interests, @operators].map(&:size).uniq.one?
    end
  end
end
