# frozen_string_literal: true

module SkillSearch
  class FilterInput
    attr_reader :department

    def initialize(params)
      @skill_ids  = params[:skill_ids]
      @levels     = params[:levels]
      @interests  = params[:interests]
      @operators  = operators(params)
      @department = params[:department]
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
      [@skill_ids, @levels, @interests].map(&:size).uniq.one?
    end

    def operators(params)
      if params[:expert_mode]
        params[:operators] || []
      else
        []
      end
    end
  end
end
