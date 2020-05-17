# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :levels, :skill_ids, :level_for_skill

  def initialize(entries, rated, level = nil, skill_id = nil)
    @entries = entries
    @rated = rated
    @levels = level.nil? ? nil : level.to_s.split(',')
    @skill_ids = skill_id.nil? ? nil : skill_id.to_s.split(',')
    unless skill_ids.nil?
      @level_for_skill = skill_ids.zip(levels).map { |ls| { skill: ls[0], level: ls[1] } }
    end
  end

  def scope
    filter_by_level(filter_by_rated)
  end

  private

  def filter_by_rated
    if rated == 'true'
      return entries.where.not(interest: 0)
                    .or(entries.where.not(level: 0))
    elsif rated == 'false'
      return entries.where(interest: 0, level: 0)
    end
    entries
  end

  def filter_by_level(entries)
    return entries if levels.nil?
    if skill_ids.length == levels.length
      return level_filter_results(entries)
    else
      raise ArgumentError, 'Amount of Skill_ids and levels provided do not match'
    end
  end

  def level_filter_results(entries)
    filtered_entries = filter_entries_by_skill_and_level(entries)
    skills_per_person = filtered_entries.group(:person_id).count
    person_ids = skills_per_person.map { |id, count| id if count == @skill_ids.length }
    entries.where(person_id: person_ids, skill_id: @skill_ids)
  end

  def filter_entries_by_skill_and_level(entries)
    base = entries.clone
    l_s = level_for_skill.clone.pop
    base = entries.where('skill_id = ? and level >= ?', l_s[:skill], l_s[:level])
    level_for_skill.each do |ls|
      base = base.or(entries.where('skill_id = ? and level >= ?', ls[:skill], ls[:level]))
    end
    base
  end
end
