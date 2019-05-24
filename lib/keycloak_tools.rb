module KeycloakTools
  def authorize_admin
    return if Rails.env.development? && ENV['ENABLE_AUTH'].blank?
    return if ENV['DISABLE_AUTH'].present?
    return if Rails.env.test? && ENV['FRONTEND_TESTS'] == 1

    return if has_admin_flag?

    render_unauthorized
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
end
