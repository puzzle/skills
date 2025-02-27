# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  include I18nHelper
  helper_method :filter_params, :no_results_message

  def entries
    return [] if filter_params.skill_ids.empty?

    required_search_values = extract_required_search_values

    return [] if required_search_values.empty?

    base = PeopleSkill.includes(:person, skill: [
      :category,
      :people, { people_skills: :person }
    ])
    PeopleSkillsFilter.new(
      base, true, required_search_values[1], required_search_values[2], required_search_values[0]
    ).scope
  end

  private

  def filter_params
    PeopleSkills::FilterParams.new(params)
  end

  def extract_required_search_values
    filtered_array = filter_params.skill_ids.zip(filter_params.levels, filter_params.interests)
    filtered_array.reject { |arr| arr.first == '' }.transpose
  end

  def no_results_message
    if filter_params.skill_ids.empty? || filter_params.skill_ids.any? { |x| x.to_i <= 0 }
      ti 'search.no_skill'
    else
      skills = filter_params.skill_ids.map { |skill_id| Skill.find(skill_id).title }
      levels = filter_params.levels.map { |level_id| ti("people_skills.levels_by_id.#{level_id}") }
      interests = filter_params.interests
      skills.zip(levels, interests).map do |skill, level, interest|
        ti("search.no_match", skill: skill, level: level, interest: interest)
      end
    end
  end

  def controller
    self
  end
end
