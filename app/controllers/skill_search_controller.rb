# frozen_string_literal: true

class SkillSearchController < CrudController
  include ParamConverters
  helper_method :filter_params, :no_match_message

  def self.model_class
    PeopleSkill
  end

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
    SkillSearch::FilterParams.new(params)
  end

  def extract_required_search_values
    filtered_array = filter_params.skill_ids.zip(filter_params.levels, filter_params.interests)
    filtered_array.reject { |arr| arr.first == '' }.transpose
  end

  def no_match_message
    skill_titles = filter_params.skill_ids.map { |skill_id| Skill.find(skill_id).title }
    levels = filter_params.levels
    interests = filter_params.interests
    combine_to_feedback_sentence(skill_titles, levels, interests)
  end

  def combine_to_feedback_sentence(skill_titles, levels, interests)
    skill_titles.zip(levels, interests).map do |skill_title, level, interest|
      "#{skill_title} (#{level}/#{interest})"
    end.to_sentence
  end
end
