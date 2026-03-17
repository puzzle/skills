class Api::CvsController < Api::ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  unless Rails.env.local?
    http_basic_authenticate_with(
      name: ENV.fetch('API_USERNAME'),
      password: ENV.fetch('API_PASSWORD')
    )
  end

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

    render json: people, each_serializer: CvSerializer
  end
end
