# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :levels_and_interests_for_skills

  # rubocop:disable Metrics/ParameterLists
  def initialize(entries, rated, levels = [], interests = [], skill_ids = [])
    @entries = entries
    @rated = rated
    @levels_and_interests_for_skills = []
    set_levels_and_interests_for_skills(levels, interests, skill_ids)
  end
  # rubocop:enable Metrics/ParameterLists

  def scope
    filter_by_level_and_interest(filter_by_rated)
  end

  private

  def set_levels_and_interests_for_skills(levels, interests, skill_ids)
    return if levels.blank? || skill_ids.blank? || interests.blank?

    levels = levels.to_s.split(',')
    interests = interests.to_s.split(',')
    skill_ids = skill_ids.to_s.split(',')

    check_query_param_length(levels, interests, skill_ids)

    # rubocop:disable Layout/LineLength
    @levels_and_interests_for_skills = skill_ids.zip(levels, interests)
                                                .map { |search_param| { skill: search_param[0], level: search_param[1], interest: search_param[2] } }
    # rubocop:enable Layout/LineLength
  end

  def check_query_param_length(levels, interests, skill_ids)
    # & is the save navigation operator and checks for nil
    if levels&.length != skill_ids&.length || interests&.length != skill_ids&.length
      raise ArgumentError, 'For each Skill there must be a level and interest present'
    end
  end

  def filter_by_rated
    case rated
    when 'true'
      return entries.where.not(interest: 0)
                    .or(entries.where.not(level: 0))
    when 'false'
      return entries.where(interest: 0, level: 0)
    end
    entries
  end

  def filter_by_level_and_interest(entries)
    return entries if levels_and_interests_for_skills.empty?

    filtered_entries = filter_for_skills_and_levels_and_interests(entries)
    skills_per_person = filtered_entries.group(:person_id).count
    person_ids = persons_with_required_skill(skills_per_person)

    # include skill and person to access name and title in query
    data = find_person_skills(entries, person_ids)

    # Serialize Data and convert to json before returning
    JSON.generate(PeopleSearchSkillSerializer.serialize(data))
  end

  def find_person_skills(entries, person_ids)
    skills_by_person(entries, person_ids).map do |person_id, skills|
      { person_id: person_id, name: skills.first.person.name, skills: map_skills(skills) }
    end
  end

  def skills_by_person(entries, person_ids)
    entries.includes(:skill, :person)
           .where(person_id: person_ids, skill_id: skill_ids)
           .group_by(&:person_id)
  end

  # rubocop:disable Metrics/MethodLength
  def map_skills(skills)
    skills.map do |skill|
      {
        people_skill_id: skill.id,
        skill_id: skill.skill_id,
        title: skill.skill.title,
        level: skill.level,
        interest: skill.interest,
        certificate: skill.certificate,
        core_competence: skill.core_competence
      }
    end
  end
  # rubocop:enable Metrics/MethodLength


  def filter_for_skills_and_levels_and_interests(entries)
    result = PeopleSkill.none
    levels_and_interests_for_skills.each do |search_param|
      result = result.or(
        filter_for_level_and_skill_and_interest(
          entries, search_param[:skill], search_param[:level], search_param[:interest]
        )
      )
    end
    result
  end

  def filter_for_level_and_skill_and_interest(entries, skill, level, interest)
    entries.where('skill_id = ? and level >= ? and interest >= ?', skill, level, interest)
  end

  def persons_with_required_skill(skills_per_person)
    skills_per_person.map { |id, count| id if count == skill_ids.length }
  end

  def skill_ids
    levels_and_interests_for_skills.map { |ls| ls[:skill] }
  end
end
