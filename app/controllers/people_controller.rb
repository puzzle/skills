# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController

  # self.permitted_attrs = %i[birthdate location
  #                           marital_status updated_by name nationality nationality2 title
  #                           competence_notes company_id email department_id shortname]

  # self.nested_models = %i[advanced_trainings activities projects
  #                         educations language_skills person_roles
  #                         people_skills categories]

  # self.permitted_relationships = %i[person_roles people_skills]




  def show
    require 'pry'; binding.pry # rubocop:disable Style/Semicolon,Lint/Debugger
    if format_odt?
      export
      return
    end
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
