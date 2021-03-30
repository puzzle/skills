# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :level

  def initialize(entries, rated, level = nil)
    @entries = entries
    @rated = rated
    @level = level
  end

  def scope
    filter_by_level(filter_by_rated)
  end

  private

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

  def filter_by_level(entries)
    level.nil? ? entries : entries.where('level >= ?', level)
  end
end
