# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  helper_method :filtered_entries

  def index
    @level = params[:level] ? Integer(params[:level]) : 1
    @interest = params[:interest] ? Integer(params[:interest]) : 1
    super
  end

  def filtered_entries
    return [] if params[:skill_id].nil?

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, params[:level], params[:interest], params[:skill_id]
    ).scope
  end
end
