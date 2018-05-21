class PersonCompetencesController < PersonRelationsController
  self.permitted_attrs = [:category, { :offer => [] }, :person_id]
end
