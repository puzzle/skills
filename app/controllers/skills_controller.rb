class SkillsController < CrudController
  include ExportController

  before_action :authorize_admin

  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  self.nested_models = %i[children parents]

  def authorize_admin
    return if Rails.env.development? && ENV['ENABLE_AUTH'].blank?
    return if ENV['DISABLE_AUTH'].present?

    return if has_admin_flag?

    render_unauthorized
  end

  def index
    return export if params[:format]
    render json: fetch_entries, each_serializer: SkillSerializer, include: '*'
  end

  def unrated_by_person
    if params[:person_id].present?
      entries = Skill.default_set.where
                     .not(id: PeopleSkill.where(person_id: params[:person_id]).pluck(:skill_id))
    else
      entries = Skill.list
    end
    render json: entries, each_serializer: SkillMinimalSerializer, include: '*'
  end

  protected

  def render_unauthorized(message = 'unauthorized')
    render json: message, status: :unauthorized
  end

  private

  def has_admin_flag?
    uri = request.env['REQUEST_URI']
    headers = request.env
    token = Keycloak.service.read_token(uri, headers)
    decoded_token = Keycloak.service.decode_and_verify(token)
    roles = decoded_token.dig(:resource_access, :'pitc-skills-frontend', :roles) || ""
    roles.include? 'ADMIN'
  end

  def fetch_entries
    entries = if params[:format]
                Skill.list
              else
                Skill.includes(:people,
                               parent_category: [:children, :parent],
                               category: [:children, :parent]).list
              end
    SkillsFilter.new(entries, params[:category], params[:title], params[:defaultSet]).scope
  end

  def export
    send_data Csv::Skillset.new(fetch_entries).export,
              type: :csv,
              disposition: disposition
  end

  def disposition
    content_disposition('attachment', filename('skillset', nil, 'csv'))
  end
end
