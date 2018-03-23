class AdvancedTrainingsController < PersonRelationsController
  self.permitted_attrs = %i[description year_from year_to person_id]
end
