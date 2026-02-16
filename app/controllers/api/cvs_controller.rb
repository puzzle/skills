class Api::CvsController < Api::ApplicationController
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
