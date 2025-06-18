# frozen_string_literal: true

module SkillSearch
  class FilterParams

    def initialize(params)
      @params = params
    end

    def skill_ids
      @params[:skill_id].presence || []
    end

    def levels
      @params[:level].presence
    end

    def interests
      @params[:interest]&.values.presence
    end

    def rows
      @params[:rows].to_i
    end

    def rows_count
      @params[:skill_id].present? ? @params[:skill_id].length : 1
    end

    def level_of_row(row_id)
      return 1 unless levels

      levels[row_id].present? ? levels[row_id].to_i : 1
    end

    def interest_of_row(row_id)
      return 1 unless interests

      interests[row_id].present? ? interests[row_id].to_i : 1
    end

    def skill_of_row(row_id)
      skill_ids[row_id]&.to_i
    end

    def query_params
      skill_params = skill_ids.to_query('skill_id')
      level_params = levels.to_query('level')
      interest_params = extract_interest_params

      return '' if [skill_params, level_params, interest_params].all?(&:empty?)

      "#{skill_params}&#{level_params}&#{interest_params}"
    end

    def extract_interest_params
      if interests.nil?
        ''
      else
        interests.map.with_index do |value, index|
          ["interest[#{index}]", value]
        end.to_h.to_query
      end
    end
  end
end
