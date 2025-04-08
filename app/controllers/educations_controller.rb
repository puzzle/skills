# frozen_string_literal: true

class EducationsController < People::PersonRelationsController
  self.permitted_attrs = %i[location title display_in_cv month_to year_to month_from year_from
                            person_id]
end
