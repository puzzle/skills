class AdvancedTrainingsController < PersonRelationsController
  self.permitted_attrs = %i[description finish_at start_at person_id]
end
