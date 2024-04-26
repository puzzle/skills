# frozen_string_literal: true

module PeopleSkills
  class Params

    def initialize(params)
      @params = params
    end

    def skill_ids
      return [] if @params[:skill_id].nil? || @params[:skill_id].blank?

      @params[:skill_id].presence
    end

    def levels
      @params[:level].presence
    end

    def interests
      @params[:interest].present? ? @params[:interest].values : nil
    end

    def rows
      @params[:rows].present? ? @params[:rows].to_i : nil
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
      skill_ids.nil? ? nil : skill_ids[row_id].to_i
    end

    def query_params
      skill_params = map_to_query_params(skill_ids, 'skill_id', false)
      level_params = map_to_query_params(levels, 'level', false)
      interest_params = map_to_query_params(interests, 'interest', true)

      return '' if skill_params.empty? && level_params.empty? && interest_params.empty?

      (skill_params + level_params + interest_params).join('&')
    end

    def map_to_query_params(query_param_values, query_param_name, include_index)
      return [''] if query_param_values.blank?

      if include_index
        return query_param_values.map.with_index do |value, index|
                 "#{query_param_name}[#{index}]=#{value}"
               end
      end

      query_param_values.map { |value| "#{query_param_name}[]=#{value}" }
    end
  end
end
