# frozen_string_literal: true

class EducationsController < PersonRelationsController
  self.permitted_attrs = %i[location title month_to year_to month_from year_from person_id]
end
