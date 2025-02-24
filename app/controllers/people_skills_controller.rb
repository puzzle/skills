# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters

  helper_method :filter_params, :find_skill_title_by_id

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

  def find_skill_title_by_id(id)
    Skill.find(id).title
  end

  def extract_required_search_values
    filtered_array = filter_params.skill_ids.zip(filter_params.levels, filter_params.interests)
    filtered_array.reject { |arr| arr.first == '' }.transpose
  end
end
