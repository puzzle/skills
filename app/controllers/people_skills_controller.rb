# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  helper_method :search_level, :search_interest

  def entries
    return [] if params[:skill_id].blank?

  def fetch_entries
    base = PeopleSkill.includes(:person, skill: [
      :category,
      :people, { people_skills: :person }
    ])
    people_skills = PeopleSkillsFilter.new(
      base, params[:rated], params[:level], params[:interest], params[:skill_id]
    ).scope
    if params.key?(:person_id)
      return people_skills.where(person_id: params[:person_id])
    end

    people_skills
  end
end
