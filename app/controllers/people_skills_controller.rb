# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters

  helper_method :search_skill, :search_level, :search_interest, :row_count, :query_params

  def entries
    return [] if params[:skill_id].blank?

    skill_ids = []
    levels = []
    interests = []

    params[:skill_id].each_with_index do |skill, index|
      if skill != ""
        skill_ids << skill.to_i
        levels << params[:level][index].to_i
        interests << params[:interest].values[index].to_i
      end
    end
    return [] if skill_ids.empty?

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, skill_ids, levels, interests
    ).scope
  end

  def row_count
    query_params
    params[:skill_id].present? ? params[:skill_id].length : 1
  end

  def query_params
    skill_ids = map_array_to_query("skill_id")
    levels = map_array_to_query("level")
    interests = map_hash_to_query("interest")
    return "" if skill_ids.nil?
    (skill_ids + levels + interests).join("&")
  end

  def map_array_to_query(query_name)
    if params["#{query_name}"].present?
      params["#{query_name}"].map do |skill|
        "#{query_name}[]=#{skill}"
      end
    end
  end

  def map_hash_to_query(query_name)
    if params["#{query_name}"].present?
      params["#{query_name}"].values.map.with_index do |skill, index|
        "#{query_name}[#{index}]=#{skill}"
      end
    end
  end

end
