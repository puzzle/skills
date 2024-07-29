# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController
  include ParamConverters
  include PeopleControllerConcerns

  self.permitted_attrs = [:birthdate, :location, :marital_status, :updated_by, :name, :nationality,
                          :nationality2, :title, :competence_notes, :company_id, :email,
                          :department_id, :shortname, :picture, :picture_cache,
                          { person_roles_attributes:
                              [:role_id, :person_role_level_id, :percent, :id, :_destroy] },
                          { language_skills_attributes:
                              [:language, :level, :certificate, :id, :_destroy] }]
  layout 'person', only: [:show]

  def index
    return flash[:alert] = I18n.t('errors.profile-not-found') if params[:alert].present?

    super
  end

  def show
    return export if format_odt?

    @person = Person.includes(projects: :project_technologies,
                              person_roles: [:role, :person_role_level]).find(@person.id)

    Ptime::UpdatePersonData.new.update_person_data(@person)
    super
  end

  def new
    @person = Ptime::UpdatePersonData.new.create_person(params[:ptime_employee_id])
    # (%w[DE EN FR] - @person.language_skills.pluck(:language)).each do |language|
    #   @person.language_skills.push(LanguageSkill.new({ language: language, level: 'A1' }))
    # end
    redirect_to(@person)

    # %w[DE EN FR].each do |language|
    #   @person.language_skills.push(LanguageSkill.new({ language: language, level: 'A1' }))
    # end
    #super
  end

  def create
    set_nationality2
    super
  end

  def update
    set_nationality2
    super
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
