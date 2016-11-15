class ActivitiesController::Person < CrudController
  self.permitted_attrs = [:description, :updated_by, :role, :technology, :year_from, :year_to]

  def fetch_entries
    Activity.where(person_id: params['person_id'])
  end
end
