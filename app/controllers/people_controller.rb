# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController
  include ParamConverters

  self.permitted_attrs = [:birthdate, :location, :marital_status, :updated_by, :name, :nationality,
                          :nationality2, :title, :competence_notes, :company_id, :email,
                          :department_id, :shortname, :picture, :picture_cache,
                          { person_roles_attributes: [:role_id, :person_role_level_id,
                                                      :percent, :id, :_destroy] }]

  def update
    if false?(params['has_nationality2']['checked'])
      params['person']['nationality2'] = nil
    end
    super
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
    Person.includes(:company).list
  end

  def person
    @person ||= Person.find(params[:person_id])
  end

  def export
    anon = params[:anon].presence || 'false'
    odt_file = Odt::Cv.new(entry, params).export
    filename = if anon == 'true'
                 'CV_Puzzle_ITC_anonymized.odt'
               else
                 filename(entry.name, 'CV_Puzzle_ITC')
               end

    send_data odt_file.generate,
              type: 'application/vnd.oasis.opendocument.text',
              disposition: content_disposition('attachment', filename)
  end
end
