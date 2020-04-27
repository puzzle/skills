# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :level

  def initialize(entries, rated, level = nil)
    @entries = entries
    @rated = rated
    @level = level
  end

  def scope
    if level.nil?
      filter_by_rated
    else
      filter_by_level
    end
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
