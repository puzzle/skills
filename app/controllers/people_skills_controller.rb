# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  include PeopleSkills

  def index
    @converted_params = Params.new(params)
    super
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def entries
    filtered_string_skills = @converted_params.skill_ids.select { |skill| skill.present? }
    return [] if filtered_string_skills.empty?

    skill_ids = filtered_string_skills.map(&:to_i)
    levels = @converted_params.levels.take(skill_ids.length).map(&:to_i)
    interests = @converted_params.interests.take(skill_ids.length).map(&:to_i)

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, levels, interests, skill_ids
    ).scope
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
