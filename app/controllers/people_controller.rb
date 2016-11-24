class PeopleController < CrudController
  self.permitted_attrs = [:birthdate, :profile_picture, :language, :location, :martial_status,
                          :updated_by, :name, :origin, :role, :title, :status_id]

  self.nested_models = [:advanced_trainings, :activities, :projects,
                        :educations, :competences]

  def index
    super(render_options: { include: [:status] })
  end
end
