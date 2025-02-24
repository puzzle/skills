# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters

  helper_method :filter_params, :find_skill_title_by_id, :get_no_match_translation

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

  def find_skill_title_by_id(id)
    Skill.find(id).title
  end

  def get_no_match_translation(index)
    if index == 0
      if index == filter_params.rows_count - 1
        "search.no_match.only_skill"
      else
        "search.no_match.first_skill"
      end
    else
      if index == filter_params.rows_count - 1
        "search.no_match.last_skill"
      else
        "search.no_match.skill"
      end
    end
  end
end