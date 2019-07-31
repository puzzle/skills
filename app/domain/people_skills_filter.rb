# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated

  def initialize(entries, rated)
    @entries = entries
    @rated = rated
  end

  def scope
    filter_by_rated
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
end
