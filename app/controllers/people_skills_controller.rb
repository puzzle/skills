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
                                  :category, :parent_category,
                                  :people, people_skills: :person
                                ])
    if params.key?(:person_id)
      people_skills = base.where(person_id: params[:person_id])
      PeopleSkillsFilter.new(people_skills, params[:rated]).scope
    elsif params.key?(:skill_id)
      base.where(skill_id: params[:skill_id])
    end
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
