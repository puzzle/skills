class ActivitiesController < PersonRelationsController
  self.permitted_attrs = %i[description role technology year_from year_to person_id]
end
