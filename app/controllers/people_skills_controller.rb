# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  include PeopleSkills

  helper_method :search_skill, :search_level, :search_interest, :row_count, :query_params

  def index
    @converted_params = Params.new(params)
    super
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def entries
    return [] if params[:skill_id].nil?

    return [] if @converted_params.skills.empty?

    skills = @converted_params.skills.select { |skill| skill.present? }.map(&:to_i)
    levels = @converted_params.levels.take(skills.length).map(&:to_i)
    interests = @converted_params.interests.take(skills.length).map(&:to_i)

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, levels, interests, skills
    ).scope
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def row_count
    params[:skill_id].present? ? params[:skill_id].length : 1
  end
end
