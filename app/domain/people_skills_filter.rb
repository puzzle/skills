# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :level, :skill_id

  def initialize(entries, rated, level = nil, skill_id = nil)
    @entries = entries
    @rated = rated
    @levels = level.nil? ? nil : level.to_s.split(',')
    @skill_ids = skill_id.nil? ? nil : skill_id.to_s.split(',')
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
    return entries if @levels.nil?
    if @skill_ids.length == @levels.length
      return level_filter_results(entries)
    else
      raise ArgumentError, 'Amount of Skill_ids and levels provided do not match'
    end
  end

  def level_filter_results(entries)
    person_ids = []
    entries.where(buildstring).group(:person_id).count.each_entry do |key, value|
      person_ids.push(key) if value == @skill_ids.length
    end
    entries.where(person_id: person_ids, skill_id: @skill_ids)
  end

  def buildstring
    result = +''
    @skill_ids.each_with_index do |skill, index|
      result.concat('(skill_id=')
            .concat(skill.to_s)
            .concat(' and level >=')
            .concat(@levels[index].to_s)
            .concat(') or ')
    end
    result.delete_suffix(' or ')
  end
end
