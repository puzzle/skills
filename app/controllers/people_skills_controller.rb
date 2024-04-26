# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  include PeopleSkills

  def index
    @converted_params = Params.new(params)
    super
  end

  # rubocop:disable Metrics/MethodLength
  def entries
    return [] if @converted_params.skills.empty?

    skills = @converted_params.skills.map(&:to_i)
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
  # rubocop:enable Metrics/MethodLength
end
