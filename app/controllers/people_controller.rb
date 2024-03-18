# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController
  include ParamConverters

  self.permitted_attrs = [:birthdate, :location, :marital_status, :updated_by, :name, :nationality,
                          :nationality2, :title, :competence_notes, :company_id, :email,
                          :department_id, :shortname, :picture, :picture_cache,
                          { person_roles_attributes: [:role_id, :person_role_level_id,
                                                      :percent, :id, :_destroy] },
                          { :advanced_trainings_attributes => {} }]

  # self.nested_models = %i[advanced_trainings activities projects
  #                         educations language_skills person_roles
  #                         people_skills categories]

  # self.permitted_relationships = %i[person_roles people_skills]

  def show
    return export if format_odt?

    @person = Person.includes(projects: :project_technologies,
                              person_roles: [:role, :person_role_level]).find(params.fetch(:id))
    super
  end

  def update
    person_params = params[:person]
    advanced_trainings = person_params[:advanced_trainings_attributes].values
    person_params[:nationality2] = nil if false?(params[:has_nationality2]&.[](:checked))

    advanced_trainings.each do |training|
      fill_missing_with_nil(training, :year_to)
      fill_missing_with_nil(training, :month_to)
    end
    super
  end

  def fill_missing_with_nil(custom_params, property)
    custom_params[property] = nil unless custom_params.key?(property)
  end

  def export
    odt_file = Odt::Cv.new(entry, params).export
    filename = if true?(params[:anon])
                 'CV_Puzzle_ITC_anonymized.odt'
               else
                 filename(entry.name, 'CV_Puzzle_ITC')
               end

    send_data odt_file.generate,
              type: 'application/vnd.oasis.opendocument.text',
              disposition: content_disposition('attachment', filename)
  end

  private

  def fetch_entries
    Person.includes(:company).list
  end

  def person
    @person ||= Person.find(params[:person_id])
  end
end
