# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController

  self.permitted_attrs = %i[birthdate location
                            marital_status updated_by name nationality nationality2 title
                            competence_notes email department_id]

  self.nested_models = %i[advanced_trainings activities projects
                          educations language_skills person_roles
                          people_skills categories]

  self.permitted_relationships = %i[person_roles people_skills]

  def index
    people = fetch_entries

    if params[:q].present?
      people = people.search(params[:q])
      people = pre_load(people)
      render json: people, each_serializer: PeopleSerializer, param: params[:q]
    else
      render json: people, each_serializer: PeopleSerializer
    end
  end

  def show
    if format_odt?
      export
      return
    end
    @person = Person.includes(projects: :project_technologies,
                              person_roles: [:role, :person_role_level]).find(params.fetch(:id))
    super
  end

  private

  def fetch_entries
    Person.list
  end

  # Load the attributes of the given people into cache
  # Without this, reflective methods accessing attributes over associations
  # would come up empty
  def pre_load(people)
    person_keys = []
    people.each do |p|
      person_keys.push p.id
    end

    Person.includes(:department, :roles, :projects, :activities,
                    :educations, :advanced_trainings, :expertise_topics)
          .find(person_keys)
  end

  def person
    @person ||= Person.find(params[:person_id])
  end

  def export
    anon = params[:anon].presence || 'false'
    odt_file = Odt::Cv.new(entry, params).export
    filename = anon == 'true' ? 'anonymized_cv.odt' : filename(entry.name, 'cv')
    send_data odt_file.generate,
              type: 'application/vnd.oasis.opendocument.text',
              disposition: content_disposition('attachment', filename)
  end
end
