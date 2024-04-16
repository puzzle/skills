# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters

  def index
      @row = params[:rows].to_i
      super
  end

  def entries
    return [] if params[:skill_id].blank?
    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, skill_ids, levels, interests
    ).scope
  end
end
