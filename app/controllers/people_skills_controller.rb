# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters

  helper_method :filter_params

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def entries
    return [] if filter_params.skill_ids.empty?

    combined_array = filter_params.skill_ids.zip(filter_params.levels, filter_params.interests)
    filtered_array = combined_array.reject { |arr| arr.first == '' }
    required_search_values = filtered_array.transpose

    return [] if required_search_values.empty?

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, required_search_values[1], required_search_values[2], required_search_values[0]
    ).scope
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def filter_params
    PeopleSkills::FilterParams.new(params)
  end
end
