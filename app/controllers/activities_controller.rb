# frozen_string_literal: true

class ActivitiesController < People::PersonRelationsController
  self.permitted_attrs = %i[description role month_to year_to month_from year_from person_id]
end