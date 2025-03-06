# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  helper_method :filter_params, :no_match_message

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

  def no_match_message
    skills = filter_params.skill_ids.map { |skill_id| Skill.find(skill_id).title }
    levels = filter_params.levels
    interests = filter_params.interests
    map_skill_level_interest_to_s(skills, levels, interests).to_sentence
  end

  def map_skill_level_interest_to_s(skills, levels, interests)
    skills.zip(levels, interests).map do |skill, level, interest|
      "#{skill} (#{level}/#{interest})"
    end
  end
end
