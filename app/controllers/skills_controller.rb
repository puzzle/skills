require 'keycloak_tools'

class SkillsController < CrudController
  include KeycloakTools
  
  before_action :authorize_admin

  self.permitted_attrs = %i[title radar portfolio default_set category_id]

  self.nested_models = %i[children parents]

  def index
    render json: fetch_entries, each_serializer: SkillSerializer, include: '*'
  end

  private

  def fetch_entries
    SkillsFilter.new(super, params[:category], params[:title], params[:defaultSet]).scope
  end
end
