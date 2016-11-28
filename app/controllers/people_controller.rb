class PeopleController < CrudController
  self.permitted_attrs = [:birthdate, :profile_picture, :language, :location, :martial_status,
                          :updated_by, :name, :origin, :role, :title, :status_id]

  self.nested_models = [:advanced_trainings, :activities, :projects,
                        :educations, :competences]

  def index
    super(render_options: { include: [:status] })
  end

  def show
    format_odt? ? export : super
  end

  private

  def export
    person = Person.find(params[:id])
    odt_file = person.export
    send_data odt_file.generate, type: 'application/vnd.oasis.opendocument.text',
                                 disposition: 'attachment',
                                 filename: filename(person.name)
  end

  def filename(name)
    "#{name.downcase.tr(' ', '_')}_cv.odt"
  end

  def format_odt?
    response.request.filtered_parameters['format'] == 'odt'
  end
end
