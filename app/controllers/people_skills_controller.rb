# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ExportController

  self.permitted_attrs = %i[person_id skill_id level interest certificate core_competence]

  self.nested_models = %i[category]

  def index
    return export if format_csv?
    if params.keys.select { |k| %w[person_id skill_id].include?(k) }.length != 1
      return head 400
    end

    render json: fetch_entries, each_serializer: PeopleSkillSerializer, include: '*'
  end

  private

  def fetch_entries
    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, people_skills: :person
                                ])
    people_skills = PeopleSkillsFilter.new(base, params[:rated]).scope
    if params.key?(:person_id)
      people_skills.where(person_id: params[:person_id])
    elsif params.key?(:skill_id)
      filter_entries(people_skills)
    end
  end

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
  end

  def export
    entries = PeopleSkill.where(person_id: params[:person_id])

    send_data Csv::PeopleSkills.new(entries).export,
              type: :csv,
              disposition: disposition
  end

  def disposition
    content_disposition('attachment', filename(person.name, 'skills', 'csv'))
  end

  def person
    @person ||= Person.find(params[:person_id])
  end
end
