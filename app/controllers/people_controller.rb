class PeopleController < CrudController
  self.permitted_attrs = [:birthdate, :picture, :language, :location, :martial_status,
                          :updated_by, :name, :origin, :role, :title, :status_id, :variation_name]

  self.nested_models = [:advanced_trainings, :activities, :projects,
                        :educations, :competences]

  skip_before_filter :authorize, :only => [:picture]

  def index
    people = fetch_entries
    people = people.search(params[:q]) if params[:q].present?

    render json: people, each_serializer: PeopleSerializer
  end

  def show
    format_odt? ? export : super
  end

  def update_picture
    person = fetch_entry(:person_id)
    person.update_attributes(picture: params[:picture])
    render json: { data: { picture_path: person_picture_path(params[:person_id]) } }
  end

  def picture
    person = fetch_entry(:person_id)
    if person.picture.file.nil?
      send_file(Rails.public_path + 'default_avatar.png', disposition: 'inline')
    else
      send_file(person.picture.url, disposition: 'inline')
    end
  end

  private

  def fetch_entry(attr = :id)
    Person.find(params.fetch(attr))
  rescue ActiveRecord::RecordNotFound
    Person::Variation.find(params.fetch(attr))
  end

  def export
    odt_file = entry.export
    send_data odt_file.generate,
      type: 'application/vnd.oasis.opendocument.text',
      disposition: 'attachment',
      filename: filename(entry.name)
  end

  def filename(name)
    "#{name.downcase.tr(' ', '_')}_cv.odt"
  end

  def format_odt?
    response.request.filtered_parameters['format'] == 'odt'
  end

end
