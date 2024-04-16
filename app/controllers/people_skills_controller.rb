# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters

  def index
    if params[:row].present?
      respond_to do |format|
        if params[:row] == "add"
          @id = SecureRandom.uuid
          format.turbo_stream { render :add_filter, status: :ok }
        else
          format.turbo_stream { render :remove_filter, status: :ok, locals: {id: params[:row] }}
        end
      end
    else
      super
    end
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
