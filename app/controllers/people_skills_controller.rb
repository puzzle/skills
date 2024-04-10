# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  helper_method :filtered_entries, :search_level, :search_interest

  def filtered_entries
    return [] if params[:skill_id].nil? || params[:skill_id] == ''

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, params[:level], params[:interest], params[:skill_id]
    ).scope
  end

  def search_level
    params[:level] ? Integer(params[:level]) : 1
  end

  def search_interest
    params[:interest] ? Integer(params[:interest]) : 1
  end
end
