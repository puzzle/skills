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
    filtered_string_skills = @converted_params.skill_ids.select { |skill| skill.present? }
    return [] if filtered_string_skills.empty?

    skill_ids = filtered_string_skills
    levels = @converted_params.levels.take(skill_ids.length)
    interests = @converted_params.interests.take(skill_ids.length)

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, levels, interests, skill_ids
    ).scope
  end
  # rubocop:enable Metrics/MethodLength
end
