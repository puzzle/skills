class ActivitiesController < PersonRelationsController
  self.permitted_attrs = %i[description role technology year_from
                            month_from year_to month_to person_id]
end
