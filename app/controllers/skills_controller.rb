class SkillsController < CrudController

  before_action :authorize_admin

  def authorize_admin
    #return if Rails.env.development? && ENV['ENABLE_AUTH'].blank?
    return if ENV['DISABLE_AUTH'].present?

    if has_admin_flag
      return
    end

    render_unauthorized
  end

  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  self.nested_models = %i[children parents]

  def index
    render json: fetch_entries, each_serializer: SkillSerializer, include: '*'
  end

  private

  def has_admin_flag
    uri = request.env['REQUEST_URI']
    headers = request.env
    token = Keycloak.service.read_token(uri, headers)
    decoded_token = Keycloak.service.decode_and_verify(token)
    roles = decoded_token['resource_access']['pitc-skills-frontend']['roles']
    roles.include? 'ADMIN'
  end

  def fetch_entries
    SkillsFilter.new(super, params[:category], params[:title], params[:defaultSet]).scope
  end
end
