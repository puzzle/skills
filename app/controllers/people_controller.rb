# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController
  include ParamConverters
  include PeopleControllerConcerns

  self.permitted_attrs = [:birthdate, :location, :marital_status, :updated_by, :name, :nationality,
                          :nationality2, :title, :competence_notes, :company_id, :email,
                          :department_id, :shortname, :picture, :picture_cache,
                          { person_roles_attributes: [:role_id, :person_role_level_id,
                                                      :percent, :id, :_destroy] },
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

    unless @person.new_record?
      @person = Person.includes(projects: :project_technologies,
                                person_roles: [:role, :person_role_level]).find(params.fetch(:id))
    end
    update_person_data
    super
  end

  def new
    ptime_employee_id = params.fetch(:ptime_employee_id)
    if ptime_employee_id
      person = Person.find_by(ptime_employee_id: ptime_employee_id)
      redirect_to action: :index unless person.nil?
      new_person = Person.includes(projects: :project_technologies,
                                   person_roles: [:role, :person_role_level]).new
      new_person.ptime_employee_id = ptime_employee_id
      @person = new_person
      redirect_to action: :show
    end
    # super
    # %w[DE EN FR].each do |language|
    #   @person.language_skills.push(LanguageSkill.new({ language: language }))
    # end
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

  def update_person_data
    attribute_mapping = { shortname: :shortname, email: :email, marital_status: :marital_status,
                          graduation: :title, company: :company, birthdate: :birthdate,
                          location: :location, nationality: :nationality }.freeze

    begin
      ptime_employee = Ptime::Client.new.get("employees/#{@person.ptime_employee_id}")['data']
    rescue RestClient::InternalServerError, RestClient::NotFoundError
      render(:index, status: :ok)
    else
      ptime_employee_firstname = ptime_employee['attributes']['firstname']
      ptime_employee_lastname = ptime_employee['attributes']['lastname']
      ptime_employee_name = "#{ptime_employee_firstname} #{ptime_employee_lastname}"
      @person.name = ptime_employee_name
      ptime_employee['attributes'].each do |key, value|
        if key.to_sym.in?(attribute_mapping.keys)
          @person[attribute_mapping[key.to_sym]] = value
        end
      end
      @person.save!
    end
  end
end
