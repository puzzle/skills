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

    levels = levels.split(',')
    interests = interests.split(',')
    skill_ids = skill_ids.split(',')

    # rubocop:disable Layout/LineLength
    @levels_and_interests_for_skills = skill_ids.zip(levels, interests)
                                                .map { |search_param| { skill: search_param[0], level: search_param[1], interest: search_param[2] } }
    # rubocop:enable Layout/LineLength
  end

  def filter_by_rated
    case rated
    when true
      return entries.where.not(interest: 0)
                    .or(entries.where.not(level: 0))
    when false
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
    find_person_skills(entries, person_ids)
  end

  def find_person_skills(entries, person_ids)
    skills_by_person(entries, person_ids).map do |person, skills|
      { person: person, skills: skills }
    end
  end

  def skills_by_person(entries, person_ids)
    entries.includes(:skill, :person)
           .where(person_id: person_ids, skill_id: skill_ids)
           .group_by(&:person)
  end

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
    levels_and_interests_for_skills.pluck(:skill)
  end
end
