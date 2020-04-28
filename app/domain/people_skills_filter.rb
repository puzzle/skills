# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated

  def initialize(entries, rated, level = 0)
    @entries = entries
    @rated = rated
    @level = level.to_s.split(',')
  end

  def scope
    filter_by_rated
  end

  def scopelevel(skills)
    filter_by_level(skills)
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

  def filter_by_level(skills)
    skill_ids = skills.to_s.split(',')
    if skill_ids.length == @level.length
      person_ids = []
      entries.where(buildstring(skill_ids)).group(:person_id).count.each_entry do |key, value|
        person_ids.push(key) if value == skill_ids.length
      end
      return entries.where(person_id: person_ids, skill_id: skill_ids)
    else
      raise ArgumentError, 'Amount of Skill_ids and levels provided do not match'
    end
  end

  def buildstring(skill_ids)
    result = +''
    for i in 0..skill_ids.length - 1 do
      result.concat('(skill_id=').concat(skill_ids[i].to_s).concat(' and level >=').concat(@level[i].to_s).concat(')').concat(' or ')
    end
    result.delete_suffix(' or ')
  end
end
