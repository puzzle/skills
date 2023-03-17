# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :levels_for_skills, :interests_for_skills

  def initialize(entries, rated, levels = [], interests = [], skill_ids = [])
    @entries = entries
    @rated = rated
    @levels_for_skills = []
    set_levels_for_skills(levels, skill_ids)
    @interests_for_skills = []
    set_interests_for_skills(interests, skill_ids)
  end

  def scope
    filter_by_level_and_interest(filter_by_rated)
  end

  private

  def set_levels_for_skills(levels, skill_ids)
    return if levels.blank? || skill_ids.blank?

    levels = levels.to_s.split(',')
    skill_ids = skill_ids.to_s.split(',')

    if levels.length != skill_ids.length
      raise ArgumentError, 'For each Skill there must be a level present'
    end

    @levels_for_skills = skill_ids.zip(levels).map { |ls| { skill: ls[0], level: ls[1] } }
  end

  def set_interests_for_skills(interests, skill_ids)
    return if interests.blank? || skill_ids.blank?

    interests = interests.to_s.split(',')
    skill_ids = skill_ids.to_s.split(',')

    if interests.length != skill_ids.length
      raise ArgumentError, 'For each Skill there must be a interest present'
    end

    @interests_for_skills = skill_ids.zip(interests).map { |ls| { skill: ls[0], interest: ls[1] } }
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
    return entries if levels_for_skills.empty? || interests_for_skills.empty?

    filtered_entries = filter_for_skills_and_levels_and_interests(entries)
    skills_per_person = filtered_entries.group(:person_id).count
    person_ids = persons_with_required_skill(skills_per_person)

    entries.where(person_id: person_ids, skill_id: skill_ids)
  end

  def filter_for_skills_and_levels_and_interests(entries)
    result = PeopleSkill.none
    levels_for_skills.each do |ls|
      result = result.or(filter_for_level_and_skill_and_interest(entries, ls[:skill], ls[:level], interests_for_skills.find { |h| h[:skill] == ls[:skill]}[:interest]))
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
    levels_for_skills.map { |ls| ls[:skill] }
  end
end
