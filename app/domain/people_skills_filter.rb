# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :level

  def initialize(entries, rated = 'true', level = '0')
    @entries = entries
    @rated = rated
    @level = level
  end

  def scope
    filter_by_rated
  end

  def scope_level
    filter_by_level
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

  def filter_by_level
    entries.where('level >= ?', level)
  end

end
