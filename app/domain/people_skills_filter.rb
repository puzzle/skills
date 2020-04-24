# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated

  def initialize(entries, rated, level = 0)
    @entries = entries
    @rated = rated
    @level = level.to_s.split(",")[0] 
  end

=begin

def filter_entries(people_skills)
  all = people_skills
  skills = params[:skill_id].split(",")
  people_skills = people_skills.where(skill_id: skills[0])
  if params.key?(:level)
    levels = params[:skill_id].split(",")      
    people_skills = people_skills.where('level >= ?', levels[0])
  end
  for i in 1..skills.size-1 
    temp = all.where(skill_is: skills[i])
    temp = temp.where('level >= ?', levels[i])
    people_skills = people_skills.join("INNER JOIN temp ON people_skills.person_id = temp.person_id")
  end
  return people_skills

=end

  def scope
    filter_by_rated
  end

  def scopelevel
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
    entries.where('level >= ?', @level)
  end
  
end