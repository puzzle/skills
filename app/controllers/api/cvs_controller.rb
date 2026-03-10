class Api::CvsController < Api::ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  http_basic_authenticate_with name: ENV.fetch('API_USERNAME'), password: ENV.fetch('API_PASSWORD'), unless: -> { Rails.env.development? }

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

  def render_collection(collection, serializer)
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(
        collection,
        each_serializer: serializer
      )
    }
  end
end
