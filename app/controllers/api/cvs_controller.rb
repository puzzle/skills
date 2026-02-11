class Api::CvsController < Api::ApplicationController
  def index
    people = Person
               .includes(
                 :company,
                 :department,
                 :language_skills,
                 :projects,
                 :activities,
                 :advanced_trainings,
                 :educations,
                 :contributions,
                 :skills,
                 person_roles: [:role, :person_role_level]
               )

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(
        people,
        each_serializer: CvSerializer,
        anon: cast_boolean(params[:anon])
      )
    }
  end

  private

  def cast_boolean(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
end
