class AdvancedTrainingsController::Person < CrudController
  self.permitted_attrs = [:description, :updated_by, :year_from, :year_to]

  def fetch_entries
    AdvancedTraining.where(person_id: params['person_id'])
  end
end
