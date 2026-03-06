class Api::CvsController < Api::ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :http_basic_authenticate!, unless: -> { Rails.env.development? }

  def index
    people = Person
             .includes(
               :company, :department,
               :language_skills,
               :projects, :activities,
               :advanced_trainings,
               :educations, :contributions, :skills,
               person_roles: [:role, :person_role_level]
             )

    render_collection(people, CvSerializer)
  end

  private

  def http_basic_authenticate!
    authenticate_or_request_with_http_basic('API') do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch('API_USERNAME')) &&
        ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch('API_PASSWORD'))
    end
  end

  def render_collection(collection, serializer)
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(
        collection,
        each_serializer: serializer
      )
    }
  end
end
