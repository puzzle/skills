# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :level, :interest

  def initialize(entries, rated, level = nil, interest = nil)
    @entries = entries
    @rated = rated
    @level = level
    @interest = interest
  end

  def scope
    filter_by_level_and_interest(filter_by_rated)
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

  def filter_by_level_and_interest(entries)
    if level.nil? && interest.nil?
      entries
    elsif level.nil?
      entries.where('level >= ?', level)
    elsif interest.nil?
      entries.where('interest >= ?', interest)
    else
      entries.where('level >= ? AND interest >= ?', level, interest)
    end
  end
end
