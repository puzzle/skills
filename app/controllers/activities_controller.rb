class ActivitiesController < PersonRelationsController
  self.permitted_attrs = %i[description role technology finish_at start_at person_id]
end
