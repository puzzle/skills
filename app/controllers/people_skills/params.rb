# frozen_string_literal: true

module PeopleSkills
  class Params

    def initialize(params)
      @params = params
    end

    def skills
      return [] if @params[:skill_id].nil? || @params[:skill_id].blank?

      @params[:skill_id].select { |skill| skill.present? }
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

    def search_level(row_id)
      return 1 if levels.nil?

      levels[row_id].present? ? levels[row_id].to_i : 1
    end

    def search_interest(row_id)
      return 1 if interests.nil?

      interests[row_id].present? ? interests[row_id].to_i : 1
    end

    def search_skill(row_id)
      skills.nil? ? nil : skills[row_id].to_i
    end

    def query_params
      skill_params = map_to_query_params(skills, 'skill_id', false)
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
