# frozen_string_literal: true

class PeopleSkillsFilter
  attr_reader :entries, :rated, :levels_and_interests_for_skills

  def initialize(entries, rated, levels = [], interests = [], skill_ids = [])
    @entries = entries
    @rated = rated
    @levels_and_interests_for_skills = []
    set_levels_and_interests_for_skills(levels, interests, skill_ids)
  end

  def scope
    filter_by_level_and_interest(filter_by_rated)
  end

  private

  def set_levels_and_interests_for_skills(levels, interests, skill_ids)
    return if levels.blank? || skill_ids.blank? || interests.blank?

    levels = levels.to_s.split(',')
    interests = interests.to_s.split(',')
    skill_ids = skill_ids.to_s.split(',')

    if levels.length != skill_ids.length || interests.length != skill_ids.length
      raise ArgumentError, 'For each Skill there must be a level and interest present'
    end

    @levels_and_interests_for_skills = skill_ids.zip(levels, interests).map { |ls| { skill: ls[0], level: ls[1], interest: ls[2] } }
  end

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
    return entries if levels_and_interests_for_skills.empty?

    filtered_entries = filter_for_skills_and_levels_and_interests(entries)
    skills_per_person = filtered_entries.group(:person_id).count
    person_ids = persons_with_required_skill(skills_per_person)

    data = entries.where(person_id: person_ids, skill_id: skill_ids).group_by(&:person_id).map do |person_id, skills|
      skills_array = skills.map do |skill|
        { skill_id: skill.skill_id, title: Skill.find(skill.skill_id).title, level: skill.level, interest: skill.interest, certificate: skill.certificate, core_competence: skill.core_competence }
      end
      person = Person.find(person_id)

      { person_id: person_id, name: person[:name], skills: skills_array }
    end

    json_api_data = {
      data: data.map do |entry|
        {
          type: 'people_skills',
          id: entry[:person_id],
          attributes: {
            person_id: entry[:person_id],
            skills: entry[:skills].map do |skill|
              {
                skill_id: skill[:skill_id],
                level: skill[:level],
                interest: skill[:interest],
                certificate: skill[:certificate],
                core_competence: skill[:core_competence]
              }
            end
          },
          relationships: {
            person: {
              data: {
                id: entry[:person_id],
                type: "people",
              }
            },
            skills: {
              data: entry[:skills].map do |skill|
                {
                  id: skill[:skill_id],
                  type: "skills"
                }
              end
            }
          }
        }
      end,
      included: data.flat_map do |entry|
        skills = entry[:skills].map do |skill|
          {
            id: skill[:skill_id],
            type: "skills",
            attributes: {
              title: skill[:title],
              default_set: skill[:default_set],
              category_id: skill[:category_id]
            },
            relationships: {
              people: {
                data: [
                  {
                    id: entry[:person_id],
                    type: "people"
                  }
                ]
              },
              category: {
                data: {
                  id: skill[:category_id],
                  type: "categories"
                }
              },
              parent_category: {
                data: {
                  id: skill[:parent_category],
                  type: "categories"
                }
              }
            }
          }
        end
        [
          {
            id: entry[:person_id],
            type: "people",
            attributes: {
              name: entry[:name],
              title: entry[:title]
            }
          },
        ] + skills
      end
    }

    JSON.generate(json_api_data)
  end

  def filter_for_skills_and_levels_and_interests(entries)
    result = PeopleSkill.none
    levels_and_interests_for_skills.each do |ls|
      result = result.or(filter_for_level_and_skill_and_interest(entries, ls[:skill], ls[:level], ls[:interest]))
    end
    result
  end

  def filter_for_level_and_skill_and_interest(entries, skill, level, interest)
    entries.where('skill_id = ? and level >= ? and interest >= ?', skill, level, interest)
  end

  def persons_with_required_skill(skills_per_person)
    skills_per_person.map { |id, count| id if count == skill_ids.length }
  end

  def skill_ids
    levels_and_interests_for_skills.map { |ls| ls[:skill] }
  end
end
