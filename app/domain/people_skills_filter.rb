# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated

  def initialize(entries, rated, level = 0)
    @entries = entries
    @rated = rated
    @level = level.to_s.split(",")
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
    skill_ids = skills.to_s.split(",")
    if skill_ids.length == @level.length
      results = entries.where(skill_id: skill_ids[0]).where('level >= ?', @level[0])
      for i in 1..(skill_ids.length - 1)
        foo = entries.where(skill_id: skill_ids[i]).where('level >= ?', @level[i])

        results = results.joins("INNER JOIN people_skills ON results.person_id = people_skills.person_id").where("people_skills.skill_id = ?", skill_ids[i]).where("people_skills.level >= ?", @level[i])
        # results INNER JOIN foo ON results.person_id = foo.person_id WHERE foo.skill_id = skill_ids[i] AND foo.level >= @level[i]
        # results INNER JOIN foo USING person_id WHERE foo.skill_id = skill_ids[i] AND foo.level >= @level[i]
      end
      return results
    else
      raise ArgumentError, "Amount of Skill_ids and levels provided do not match"
    end
  end
  
end
