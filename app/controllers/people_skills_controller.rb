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
    params[:skill_id].present? ? params[:skill_id].length : 1
  end
end
