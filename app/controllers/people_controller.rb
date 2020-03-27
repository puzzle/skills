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
    people = people.search(params[:q]) if params[:q].present?

    render json: people, each_serializer: PeopleSerializer
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

  def person
    @person ||= Person.find(params[:person_id])
  end

  # rubocop:disable Metrics/LineLength
  def export(anon = params[:anon].presence || 'false')
    odt_file = Odt::Cv.new(entry).export(anon != 'false')
    send_data odt_file.generate,
              type: 'application/vnd.oasis.opendocument.text',
              disposition: content_disposition('attachment',
                                               anon != 'false' ? 'cv.odt' : filename(entry.name, 'cv'))
  end
  # rubocop:enable Metrics/LineLength
end
