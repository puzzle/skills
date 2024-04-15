# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  helper_method :search_level, :search_interest

  def entries
    return [] if params[:skill_id].blank?

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, params[:level], params[:interest], params[:skill_id]
    ).scope
  end

  def search_level
    params[:level] ? params[:level].to_i : 1
  end

  def search_interest
    params[:interest] ? params[:interest].to_i : 1
  end
end
