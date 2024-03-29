# frozen_string_literal: true

class Api::ActivitiesController < Api::PersonRelationsController
  self.permitted_attrs = %i[description role technology year_from
                            month_from year_to month_to person_id]
end
