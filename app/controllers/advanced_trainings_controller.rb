class AdvancedTrainingsController < PersonRelationsController
  self.permitted_attrs = [:description, :year_from, :year_to]

  def fetch_entries
    AdvancedTraining.where(person_id: params['person_id'])
  end
end
