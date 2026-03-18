class Api::CvsController < Api::ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  unless Rails.env.local?
    http_basic_authenticate_with(
      name: ENV.fetch('API_USERNAME'),
      password: ENV.fetch('API_PASSWORD')
    )
  end

  def index
    unless params[:per_page]
      return redirect_to url_for(request.query_parameters.merge(per_page: 15))
    end

    people = paginated_people
    render json: people, each_serializer: CvSerializer
  end

  private

  def paginated_people
    per_page = params.fetch(:per_page, 15).to_i
    page = params.fetch(:page, 1).to_i

    Person
      .includes(
        :company, :department, :language_skills,
        :projects, :activities, :advanced_trainings,
        :educations, :contributions, :skills,
        person_roles: [:role, :person_role_level]
      )
      .limit(per_page).offset((page - 1) * per_page)
  end
end
