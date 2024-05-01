# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters

  helper_method :filter_params

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def entries
    filtered_string_skills = filter_params.skill_ids.select { |skill| skill.present? }
    return [] if filtered_string_skills.empty?

    skill_ids = filtered_string_skills
    levels = filter_params.levels.take(skill_ids.length)
    interests = filter_params.interests.take(skill_ids.length)

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, levels, interests, skill_ids
    ).scope
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def filter_params
    PeopleSkills::FilterParams.new(params)
  end
end
