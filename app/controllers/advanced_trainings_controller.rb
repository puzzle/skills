class AdvancedTrainingsController < PersonRelationsController
  self.permitted_attrs = %i[description year_to month_to year_from month_from person_id]
end
