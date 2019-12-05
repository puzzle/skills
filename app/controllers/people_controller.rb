# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController

  self.permitted_attrs = %i[birthdate location
                            marital_status updated_by name nationality nationality2 title
                            competence_notes company_id email department_id]

  self.nested_models = %i[advanced_trainings activities projects
                          educations language_skills people_roles
                          people_skills categories]

  self.permitted_relationships = %i[people_roles people_skills]

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
                                           people_roles: :role).find(params.fetch(:id))
    super
  end

  private

  def fetch_entries
    Person.includes(:company).list
  end

  def person
    @person ||= Person.find(params[:person_id])
  end

  def export
    odt_file = Odt::Cv.new(entry).export
    send_data odt_file.generate,
              type: 'application/vnd.oasis.opendocument.text',
              disposition: content_disposition('attachment', filename(entry.name, 'cv'))
  end
end
