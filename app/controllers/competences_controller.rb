class CompetencesController < PersonRelationsController
  self.permitted_attrs = [:description]

  def fetch_entries
    Competence.where(person_id: params['person_id'])
  end

end
