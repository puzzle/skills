# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController
  include ParamConverters
  include PeopleControllerConcerns

  helper_method :default_branch_adress

  layout 'person', only: [:show]

  before_action :redirect_index_if_use_ptime_sync, only: [:new]

  def index
    return flash[:alert] = I18n.t('errors.messages.profile-not-found') if params[:alert].present?

    super
  end

  def show
    return export if format_odt?

    @person = Person.includes(projects: :project_technologies,
                              person_roles: [:role, :person_role_level]).find(params.fetch(:id))
    super
  end

  def new
    super
    @person.nationality = 'CH'
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
    cv = Odt::Cv.new(entry, params)
    odt_file = Odt::PuzzleCv.new(cv).export
    filename = if true?(params[:anon])
                 'CV_Puzzle_ITC_anonymized.odt'
               else
                 filename(entry.name, 'CV_Puzzle_ITC')
               end

    send_data odt_file.generate,
              type: 'application/vnd.oasis.opendocument.text',
              disposition: content_disposition('attachment', filename)
  end

  def export_redhat
    cv = Odt::Cv.new(entry, params)
    odt_file = Odt::RedhatCv.new(cv).export
    initials = entry.name.rpartition(' ').then do |first_part, _, last_part|
      "#{first_part[0]}#{last_part[0]}"
    end
    filename = initials << '_Red_Hat_Services_CV.odt'

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

  def default_branch_adress
    BranchAdress.find_by(default_branch_adress: true) || BranchAdress.first
  end

  @ptime_permitted_attrs =
    [
      :updated_by, :picture, :picture_cache, :competence_notes,
      :display_competence_notes_in_cv,
      { language_skills_attributes: [[:language, :level, :certificate, :id, :_destroy]] }
    ]

  @default_permitted_attrs =
    [
      :birthdate, :location, :marital_status, :updated_by, :name,
      :nationality, :nationality2, :title, :competence_notes, :company_id, :email,
      :department_id, :shortname, :picture, :picture_cache, :display_competence_notes_in_cv,
      :reminder_mails_active,
      {
        person_roles_attributes: [[:role_id, :person_role_level_id, :percent, :id, :_destroy]],
        language_skills_attributes: [[:language, :level, :certificate, :id, :_destroy]]
      }
    ]

  self.permitted_attrs = Skills.use_ptime_sync? ? @ptime_permitted_attrs : @default_permitted_attrs

  def redirect_index_if_use_ptime_sync
    redirect_to root_path if Skills.use_ptime_sync?
  end
end
